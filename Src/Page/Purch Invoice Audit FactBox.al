pageextension 50140 "Purch Invoice Audit FactBox"
    extends "Purchase Invoice"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(PurchApprovalAudit; "Purch Approval Audit List")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }
}
