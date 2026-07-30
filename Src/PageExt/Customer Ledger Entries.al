pageextension 50134 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    actions
    {
        addlast(processing)
        {
            action(FixLCYAmount)
            {
                Caption = 'Fix LCY Amount (Temp)';
                ApplicationArea = All;
                Image = Refresh;

                trigger OnAction()
                var
                // Fixer: Codeunit "Fix Cust Ledg Entry LCY";
                begin
                    //Fixer.FixEntry();
                end;
            }
        }
    }
}