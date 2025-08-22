pageextension 50109 "Job PlanningLines EXT" extends "Job Planning Lines"
{
    layout
    {
        addafter("Invoiced Amount (LCY)")
        {
            field("SEQNO S365"; Rec."SEQNO S365")
            {
                ApplicationArea = All;
            }
            field("Predecessor Seq S365"; Rec."Predecessor Seq S365")
            {
                ApplicationArea = All;
            }
            field("Completed S365"; Rec."Completed S365")
            {
                ApplicationArea = All;
            }
        }
        addafter(Quantity)
        {
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the currency that is used on the entry.';

            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(SendNotifyS365)
            {
                Caption = 'Send Notification';
                Image = SendMail;
                ApplicationArea = Suite;
                ToolTip = 'Notification email will be send after configure email accounts';

                trigger OnAction()
                begin
                    Message('Notification email will be send after configure email accounts');
                end;
            }
            action(CreateWhseRcpS365)
            {
                Caption = 'Send Whse Notification';
                Image = SendMail;
                ApplicationArea = Suite;
                ToolTip = 'Notification email & Whse Receipt will be create';

                trigger OnAction()
                var
                    SQModFunc: Codeunit "SQmodFunction S365";
                begin
                    SQModFunc.CreateWarehouseReceipt(Rec."Job No.");
                end;
            }
            action(CreatePurchaseOder)
            {
                ApplicationArea = All;
                Caption = 'Create Purchase Order';
                Image = Purchase;
                ToolTip = 'Create a new purchase order based on the job planning line details.';
                trigger OnAction()
                begin
                    this.CreatePurchaseOrder();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("SendNotifyS365_Promoted"; SendNotifyS365)
            {
            }
            actionref("CreatePurchaseOder_Promoted"; CreatePurchaseOder)
            {
            }
        }
    }

    local procedure CreatePurchaseOrder()
    var
        PurchPaybleSetup: Record "Purchases & Payables Setup";
        PurchaseHeader: Record "Purchase Header";
        Project: Record Job;
        Noseries: Codeunit "No. Series";
        ConfimDialog: Page "Vendor Confirmation Dialog";
        POSucessMsg: Label 'Purchase Order created successfully.  %1', Locked = true;
    begin
        PurchPaybleSetup.Get();
        ConfimDialog.LookupMode(true);
        if ConfimDialog.RunModal() = Action::LookupOK then begin
            if not PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, ConfimDialog.GetPurchaseOrderNo()) then begin
                PurchaseHeader.LockTable();
                PurchaseHeader.Init();
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                //PurchaseHeader."No." := ConfimDialog.GetPurchaseOrderNo();
                PurchaseOrderNo := Noseries.GetNextNo(PurchPaybleSetup."Order Nos.", Today, true);
                PurchaseHeader."No." := PurchaseOrderNo;
                PurchaseHeader.Validate("Buy-from Vendor No.", ConfimDialog.GetVendorCode());
                PurchaseHeader.Insert(true);
                if Project.Get(Rec."Job No.") then begin
                    PurchaseHeader.Validate("Shortcut Dimension 1 Code", Project."Global Dimension 1 Code");
                    PurchaseHeader.Validate("Shortcut Dimension 2 Code", Project."Global Dimension 2 Code");
                end;
                this.CreatePurchaseLine(PurchaseHeader."No.", 0);
            end
            else begin
                UpdateExisitingPurchaseLine(PurchaseHeader);
            end;
            Message(POSucessMsg, PurchaseHeader."No.");
        end;
    end;

    local procedure UpdateExisitingPurchaseLine(var PurchaseHeader: Record "Purchase Header")
    begin
        this.CreatePurchaseLine(PurchaseHeader."No.", GetLastLineNo(PurchaseHeader."No."));
    end;

    local procedure GetLastLineNo(DocumentNumber: Code[20]): Integer
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", DocumentNumber);
        if PurchaseLine.FindLast() then
            exit(PurchaseLine."Line No.");
    end;

    local procedure CreatePurchaseLine(DocumentNo: Code[20]; LineNumber: Integer)
    var
        PurchaeLine: Record "Purchase Line";
        JobPlanningLine: Record "Job Planning Line";
        LineNo: Integer;
    begin
        PurchaeLine.LockTable();
        JobPlanningLine.Reset();
        JobPlanningLine.CopyFilters(Rec);
        CurrPage.SetSelectionFilter(JobPlanningLine);
        LineNo := LineNumber;
        if JobPlanningLine.FindSet() then
            repeat
                LineNo += 10000;
                PurchaeLine.Init();
                PurchaeLine.Validate("Document Type", PurchaeLine."Document Type"::Order);
                PurchaeLine.Validate("Document No.", DocumentNo);
                PurchaeLine."Line No." := LineNo;
                case JobPlanningLine.Type of
                    JobPlanningLine.Type::Item:
                        PurchaeLine.Validate(Type, PurchaeLine.Type::Item);
                    JobPlanningLine.Type::"G/L Account":
                        PurchaeLine.Validate(Type, PurchaeLine.Type::"G/L Account");
                    JobPlanningLine.Type::Resource:
                        PurchaeLine.Validate(Type, PurchaeLine.Type::Resource);
                end;
                PurchaeLine.Validate("No.", JobPlanningLine."No.");
                PurchaeLine.Validate(Quantity, JobPlanningLine.Quantity);
                PurchaeLine.Validate("Unit Price (LCY)", JobPlanningLine."Unit Cost");
                PurchaeLine.Validate("Job No.", JobPlanningLine."Job No.");
                PurchaeLine.Validate("Job Task No.", JobPlanningLine."Job Task No.");
                PurchaeLine.Insert();
            until JobPlanningLine.Next() = 0;
    end;

    var
        PurchaseOrderNo: Code[20];
}
