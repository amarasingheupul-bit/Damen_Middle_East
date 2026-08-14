pageextension 50124 "4HC Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
    }

    actions
    {
        addlast("P&osting")
        {
            action(CreditNote)
            {
                Caption = 'Print';
                Image = Print;
                Ellipsis = true;
                ApplicationArea = All;
                ToolTip = 'Prepares and prints the purchase credit note. This action opens the report request page, allowing you to specify printing options before generating the document.';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("Document Type", Rec."Document Type");
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    Report.Run(Report::"4HC Purchase Credit Note", true, true, PurchaseHeader);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref(CreditNote_Promoted; CreditNote)
            {
            }
        }
    }
}