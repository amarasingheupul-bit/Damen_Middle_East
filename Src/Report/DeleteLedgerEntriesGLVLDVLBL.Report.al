report 50116 "Delete Entries GL/VL/DVL/BL"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Delete Ledger Entries';
    ApplicationArea = All;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = RIMD,
                  tabledata "Vendor Ledger Entry" = RIMD,
                  tabledata "Detailed Vendor Ledg. Entry" = RIMD,
                  tabledata "Bank Account Ledger Entry" = RIMD;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }

        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }
        dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            RequestFilterFields = "Document No.";
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

        }

    }
}