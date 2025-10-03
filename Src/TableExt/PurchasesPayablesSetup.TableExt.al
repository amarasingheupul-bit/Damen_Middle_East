tableextension 50117 "4HC Purchases & Payables Setup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50101; "Block Invoice Posting"; Boolean)
        {
            Caption = 'Block Invoice Posting';
        }
        field(50100; "Enable Email Approval"; Boolean)
        {
            Caption = 'Enable Email Approval';
        }
        field(50102; "Apply Field Visibility Rules"; Boolean)
        {
            Caption = 'Apply Field Visibility Rules';
        }
    }
}
