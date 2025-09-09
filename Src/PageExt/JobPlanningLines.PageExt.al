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
                    PurchaseHeader.Validate("Shortcut Dimension 1 Code", Rec."Job No.");
                    PurchaseHeader.Validate("Shortcut Dimension 2 Code", Project."Global Dimension 2 Code");

                    // ...Copy SO code...
                    PurchaseHeader.Validate("Change Reason S365", Project."Change Reason S365");
                    PurchaseHeader.Validate("Original Quote No. S365", Project."Original Quote No. S365");
                    PurchaseHeader.Validate("ConfirmedS365", Project."ConfirmedS365");
                    PurchaseHeader.Validate("Quote Status S365", Project."Quote Status S365");
                    PurchaseHeader.Validate("Job TemplateS365", Project."Job TemplateS365");
                    PurchaseHeader.Validate("Sales Director/ Area Director", Project."Sales Director/ Area Director");
                    PurchaseHeader.Validate("Sales/ Area Director Name", Project."Sales/ Area Director Name");
                    PurchaseHeader.Validate("External Approver 2 No.", Project."Sales Secretary No.");
                    PurchaseHeader.Validate("Sales Secretary Name", Project."Sales Secretary Name");
                    PurchaseHeader.Validate("Sales Contract No.", Project."Sales Contract No.");
                    PurchaseHeader.Validate("Sales Contract Desc", Project."Sales Contract Desc");
                    PurchaseHeader.Validate("Yard No.", Project."Yard No.");
                    PurchaseHeader.Validate("Milestones Dates and Amounts", Project."Milestones Dates and Amounts");
                    PurchaseHeader.Validate("End User/ Main Customer", Project."End User/ Main Customer");
                    PurchaseHeader.Validate("Supplier to Services", Project."Supplier to Services");
                    PurchaseHeader.Validate("Sales Area", Project."Sales Area");
                    PurchaseHeader.Validate("Cost Center", Project."Cost Center");
                    PurchaseHeader.Validate(Budget, Project.Budget);
                    PurchaseHeader.Validate("Service Provider No.", Project."Service Provider No.");
                    PurchaseHeader.Validate("Sales Manager", Project."Sales Manager");
                    PurchaseHeader.Validate("Bank Details", Project."Bank Details");
                    PurchaseHeader.Validate("4HC Type", Project."4HC Type");
                    PurchaseHeader.Validate("OPCO Customer", Project."OPCO Customer");
                    PurchaseHeader.Validate("COST Reference", Project."COST Reference");
                    PurchaseHeader.Validate("G/L Account", Project."G/L Account");
                    PurchaseHeader.Validate("Incoming PO", Project."Incoming PO");
                    PurchaseHeader.Validate("Currency Code", Project."Currency Code");
                    PurchaseHeader.Validate("Sales Order No. 4HC", Project."Sales Order No. 4HC");
                    PurchaseHeader.Modify();
                    // ...Copy SO code...
                end;
                this.CreatePurchaseLine(PurchaseHeader."No.", 0);
            end
            else
                this.UpdateExisitingPurchaseLine(PurchaseHeader);

            Message(POSucessMsg, PurchaseHeader."No.");
        end;
    end;

    local procedure UpdateExisitingPurchaseLine(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader.Status = PurchaseHeader.Status::Released then begin
            PurchaseHeader.Status := PurchaseHeader.Status::Open;
            PurchaseHeader.Modify();
        end;
        this.CreatePurchaseLine(PurchaseHeader."No.", this.GetLastLineNo(PurchaseHeader."No."));
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
                PurchaeLine.Validate(Description, JobPlanningLine.Description);
                PurchaeLine.Validate(Quantity, JobPlanningLine.Quantity);
                PurchaeLine.Validate("Unit Cost", JobPlanningLine."Unit Cost");
                PurchaeLine.Validate("Unit Price (LCY)", JobPlanningLine."Unit Price (LCY)");
                PurchaeLine.Validate("Job No.", JobPlanningLine."Job No.");
                PurchaeLine.Validate("Job Task No.", JobPlanningLine."Job Task No.");
                PurchaeLine.Validate("Job Planning Line No.", JobPlanningLine."Line No.");
                PurchaeLine.Validate("Job Currency Code", JobPlanningLine."Currency Code");
                PurchaeLine.Validate("Job Currency Factor", JobPlanningLine."Currency Factor");
                PurchaeLine.Validate("Job Line Amount", JobPlanningLine."Line Amount");
                PurchaeLine.Validate("Job Unit Price", JobPlanningLine."Unit Price");
                PurchaeLine.Validate("Job Unit Price (LCY)", JobPlanningLine."Unit Price (LCY)");
                PurchaeLine.Validate("Direct Unit Cost", JobPlanningLine."Unit Cost");
                PurchaeLine.Insert();
            until JobPlanningLine.Next() = 0;
    end;

    var
        PurchaseOrderNo: Code[20];
}
