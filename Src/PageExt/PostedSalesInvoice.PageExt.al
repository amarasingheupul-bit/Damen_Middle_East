pageextension 50126 "4HC Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Print)
        {
            action(TaxInvoice)
            {
                Caption = 'Tax Invoice';
                Image = TaxPayment;
                ToolTip = 'Generates the Tax Invoice for the selected sales order.';
                ApplicationArea = Suite;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"4HC Posted Tax Invoice", true, true, SalesInvHeader);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(TaxInvoice_Promoted; TaxInvoice)
            {
            }
        }
    }
}