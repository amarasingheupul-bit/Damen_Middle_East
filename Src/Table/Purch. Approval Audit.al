table 50107 "Purch. Approval Audit"
{
    DataClassification = CustomerContent;
    Caption = 'Purchase Approval Audit';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }

        field(2; "Document Type"; Enum "Purchase Document Type") { }
        field(3; "Document No."; Code[20]) { }
        field(4; "Invoice No"; Code[20]) { }

        field(5; "Vendor No."; Code[20]) { }
        field(6; "Vendor Name"; Text[100]) { }

        field(7; "Purchase Officer"; Code[20]) { } // Purchaser Code
        field(8; "Sender ID"; Code[50]) { }        // User who sent approval
        field(9; "Sent To User"; Code[50]) { }      // Approver

        field(10; "Approver Level 1"; Code[50]) { }
        field(11; "Approver Level 2"; Code[50]) { }
        field(12; "Sales Secretary"; Text[100]) { }
        field(13; "Area Director"; Text[100]) { }

        field(14; "Amount"; Decimal) { }
        field(15; "Currency Code"; Code[10]) { }

        field(16; "Sent DateTime"; DateTime) { }
        field(17; "Email Approval Status"; Enum "4HC PAutoApprovalStatus") { }
        field(18; "Status Updated At"; DateTime) { }
        field(19; "Invoice Status"; Enum "Purchase Document Status") { }
        field(20; "Approver 1 Sent DateTime"; DateTime) { Caption = 'Approver 1 Sent DateTime'; }
        field(21; "Approver 2 Sent DateTime"; DateTime) { Caption = 'Approver 2 Sent DateTime'; }
        field(22; "Approver1 to Approver2 Duration"; Duration) { Caption = 'Approver 1 to 2 Duration'; }

    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Document; "Document No.") { }
    }
}
