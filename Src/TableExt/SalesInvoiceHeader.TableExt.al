tableextension 50115 "4HC Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50102; "Quote Type S365"; Code[10])
        {
            Caption = 'Quote Type';
            DataClassification = CustomerContent;
            TableRelation = "Quote Type S365"."Code S365";
        }
        field(50103; "Change Reason S365"; Code[10])
        {
            Caption = 'Change Reason';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code".Code;
        }
        field(50105; "Original Quote No. S365"; Code[20])
        {
            Caption = 'Original Quote No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50106; "Amend & Archived S365"; Boolean)
        {
            Caption = 'Amend & Archived';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50107; "ConfirmedS365"; Boolean)
        {
            Caption = 'Confirmed';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50109; "Quote Status S365"; Enum "Qoute Status S365")
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Status';
        }
        field(50108; "Job TemplateS365"; Code[20])
        {
            Caption = 'Job No. Template';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50117; "Job No. S365"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No';
            Editable = false;
        }
        field(50122; "Sales Director/ Area Director"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Dimension".Code where(Blocked = const(false));
            //TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7), Blocked=const(false));
            TableRelation = "Salesperson/Purchaser".Code;
            Caption = 'Sales Director/ Area Director';
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if Salesperson.Get("Sales Director/ Area Director") then
                    "Sales/ Area Director Name" := Salesperson.Name
                else
                    "Sales/ Area Director Name" := '';
            end;
        }
        field(50132; "Sales/ Area Director Name"; Text[100])
        {
            Caption = 'Sales/ Area Director Name';
        }
        field(50133; "Sales Secretary No."; Code[20])
        {
            Caption = 'Sales Secretary No.';
            TableRelation = "Salesperson/Purchaser".Code;
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if Salesperson.Get("Sales Secretary No.") then
                    "Sales Secretary Name" := Salesperson.Name
                else
                    "Sales Secretary Name" := '';
            end;
        }
        field(50134; "Sales Secretary Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Secretary Name';
        }
        field(50123; "Sales Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Contract No.';
        }
        field(50124; "Sales Contract Desc"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Contract Description';
        }
        field(50125; "Yard No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Yard No.';
        }
        field(50126; "Milestones Dates and Amounts"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Milestones with Dates and Amounts';
        }
        field(50127; "End User/ Main Customer"; Text[100])
        {
            Caption = 'End User';
            DataClassification = ToBeClassified;
        }
        field(50128; "Group Customer with One Stream"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Group Customer with One Stream Code';
            TableRelation = Customer;
            ObsoleteState = Pending;
            ObsoleteTag = '4HC25710';
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get("Group Customer with One Stream") then
                    "Group Customr Name" := Customer.Name
                else
                    "Group Customr Name" := '';
            end;
        }
        field(50131; "Group Customr Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Group Customr Name';
            ObsoleteState = Pending;
            ObsoleteTag = '4HC25710';
        }
        field(50129; "Supplier to Services"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            Caption = 'Supplier to Services';
        }
        field(50130; "Sales Area"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Area';
            // CaptionClass = '1,2,3';
            // Caption = 'Shortcut Dimension 1 Code';
            //    TableRelation = "Dimension".Code where(Blocked = const(false));
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6), Blocked = const(false));
        }
        field(50135; "Cost Center"; Text[100])
        {
            Caption = 'Cost Center';
        }
        field(50136; "Budget"; Decimal)
        {
            Caption = 'Budget';
            DataClassification = ToBeClassified;
        }
        field(50137; "Service Provider No."; Code[20])
        {
            Caption = 'Service Provider No';
            DataClassification = ToBeClassified;
        }
        field(50138; "Sales Manager"; Code[20])
        {
            Caption = 'Sales Manager';
            DataClassification = ToBeClassified;
        }
        field(50140; "Bank Details"; Text[100])
        {
            Caption = 'Bank Details';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(50100; "4HC Type"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(50101; "OPCO Customer"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'OPCO Customer';
        }
        field(50104; "COST Reference"; Text[30])
        {
            Caption = 'COST Reference';
        }
        field(50110; "G/L Account"; Text[30])
        {
            Caption = 'G/L Account';
        }
        field(50111; "Incoming PO"; Text[30])
        {
            Caption = 'Incoming PO';
        }
    }
}