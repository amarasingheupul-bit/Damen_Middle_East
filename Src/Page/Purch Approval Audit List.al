page 50119 "Purch Approval Audit List"
{
    PageType = List;
    SourceTable = "Purch. Approval Audit";
    Caption = 'Purchase Approval Audit';
    ApplicationArea = All;
    UsageCategory = Lists;

    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type") { }
                field("Document No."; "Document No.") { }
                field("Vendor No."; "Vendor No.") { }
                field("Vendor Name"; "Vendor Name") { }
                field("Purchase Officer"; "Purchase Officer") { }
                field("Sendor ID"; "Sender ID") { }
                field("Sent To User"; "Sent To User") { }
                field("Approver Level 1"; "Approver Level 1") { }
                field("Approver Level 2"; "Approver Level 2") { }
                field("Sales Secretary"; "Sales Secretary") { }
                field("Area Director"; "Area Director") { }
                field(Amount; Amount) { }
                field("Currency Code"; "Currency Code") { }
                field("Sent DateTime"; "Sent DateTime") { }
                field("Email Approval Status"; "Email Approval Status") { }
                field("Invoice Status"; "Invoice Status") { }
                field("Status Updated At"; "Status Updated At") { }


            }
        }
    }
}
