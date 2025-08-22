pageextension 50107 SalesOrderS365 extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Job No. S365"; Rec."Job No. S365")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnAssistEdit()
                var
                    RecJob: Record Job;
                    JobCardPageID: Integer;
                begin
                    JobCardPageID := PAGE::"Job Card";
                    if RecJob.Get(Rec."Job No. S365") then PAGE.RUN(JobCardPageID, RecJob);
                end;
            }
        }
        addafter(General)
        {
            group("New Fields S365")
            {
                ShowCaption = true;
                Caption = 'Additional Order Details';

                field("Place of Receipt S365"; Rec."Origin S365")
                {
                    Caption = 'Place of Receipt';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Receipt field.';
                }
                field("Place of Delivery S365"; Rec."Destination S365")
                {
                    Caption = 'Place of Delivery';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Delivery field.';
                }
                field("ETD S365"; Rec."ETD S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETD field.';
                    Visible = false;
                }
                field("ETA S365"; Rec."ETA S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA field.';
                    Visible = false;
                }
                field("Shipment Method Code S365"; Rec."Shipment Method Code")
                {
                    Caption = 'Incoterms';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoterms field.';
                    Visible = false;
                }
                field("MAWB No. S365"; Rec."MAWB No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB No. field.';
                    Visible = false;
                }
                field("MAWB Date S365"; Rec."MAWB Date S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB Date field.';
                    Visible = false;
                }
                field("Cross Trade S365"; Rec."Cross Trade S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cross Trade field.';
                    Visible = false;
                }
                field("Container No. S365"; Rec."Container No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container No. field.';
                    Visible = false;
                }
                field("Remarks S365"; Rec."Remarks S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Sales Derector/ Area Director"; Rec."Sales Derector/ Area Director")
                {
                    ApplicationArea = All;
                }
                field("Sales/ Area Director Name"; Rec."Sales/ Area Director Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales/ Area Director Name field.';
                    Editable = false;
                }
                field("Sales Secretary No."; Rec."Sales Secretary No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Secretary No. field.', Comment = '%';
                }
                field("Sales Secretary Name"; Rec."Sales Secretary Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Secretary Name field.', Comment = '%';
                }
                field("Sales Contract No."; Rec."Sales Contract No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Contract Desc"; Rec."Sales Contract Desc")
                {
                    ApplicationArea = All;
                }
                field("Yard No."; Rec."Yard No.")
                {
                    ApplicationArea = All;
                }
                field("Milestones Dates and Amounts"; Rec."Milestones Dates and Amounts")
                {
                    ApplicationArea = All;
                }
                field("End User/ Main Customer"; Rec."End User/ Main Customer")
                {
                    ApplicationArea = All;
                }
                field("Supplier to Services"; Rec."Supplier to Services")
                {
                    ApplicationArea = All;
                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("CreateJob S365")
            {
                Caption = 'Create Job';
                Image = CreateJobSalesInvoice;
                ToolTip = 'Create Job';
                ApplicationArea = Suite;

                // Visible = IsActionVisible;
                trigger OnAction()
                var
                    Func: Codeunit "SQmodFunction S365";
                begin
                    Func.CreateJobFromTemplate(Rec);
                end;
            }
            action(TaxInvoice)
            {
                Caption = 'Tax Invoice';
                Image = TaxPayment;
                ToolTip = 'Generates the Tax Invoice for the selected sales order.';

                ApplicationArea = Suite;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"4HC Tax Invoice", true, true, SalesHeader);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("CreateJob_Promoted S365"; "createJob S365")
            {
            }
            actionref(TaxInvoice_Promoted; TaxInvoice)
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsActionVisible := false;
        if Rec."Job TemplateS365" <> '' then IsActionVisible := true;
    end;

    var
        IsActionVisible: Boolean;
}
