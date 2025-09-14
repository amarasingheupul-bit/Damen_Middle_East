tableextension 50116 "4HC Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount';
            DataClassification = CustomerContent;
        }
        field(50101; "OPCO Com Project No."; Code[50])
        {
            Caption = 'OPCO Com Project No.';
            DataClassification = CustomerContent;
        }
        field(50102; "SPA Date"; Date)
        {
            Caption = 'SPA Date';
            DataClassification = CustomerContent;
        }
        field(50103; "Amendment Date"; Date)
        {
            Caption = 'Amendment Date';
            DataClassification = CustomerContent;
        }
        field(50125; "Yard No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50126; "Milestones Dates and Amounts"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Milestones with Dates and Amounts';
        }
        field(50128; "Group Customer with One Stream"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Group Customer with One Stream Code';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get("Group Customer with One Stream") then
                    "Group Customr Name" := Customer.Name;
            end;
        }
        field(50104; "Group Customr Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Group Customer Name';
        }
        field(50105; "Sales/ Area Director Name"; Text[100])
        {
            Caption = 'Sales/ Area Director Name';
        }
        field(50106; "Vessel Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Type';
        }
        field(50107; "Cost Reference"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cost Reference';
        }
        field(50108; "Quote Type"; Code[10])
        {
            Caption = 'Quote Type';
            DataClassification = CustomerContent;
            TableRelation = "Quote Type S365"."Code S365";
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
        field(50137; "Sales Provider No."; Code[20])
        {
            Caption = 'Sales Provider No';
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
        field(50109; "Email Approval Status"; Enum "4HC PAutoApprovalStatus")
        {
            DataClassification = ToBeClassified;
            Caption = 'Email Approval Status';
        }
        field(50110; "SalesDirecotor Email"; Text[80])
        {
            Caption = 'Sales Director Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser"."E-Mail" where(Code = field("Purchaser Code")));
        }
        field(50112; "Sales Secretary Email"; Text[80])
        {
            Caption = 'Sales Secretary Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser"."E-Mail" where(Code = field("Sales Secretary No.")));
        }
        field(50111; "Approval Rejection Reason"; Text[250])
        {
            Caption = 'Approval Rejection Reason';
            DataClassification = CustomerContent;
        }
        field(50133; "Sales Secretary No."; Code[20])
        {
            Caption = 'Sales Secretary No.';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        //field from Sales Header Table
        field(50113; "Change Reason S365"; Code[10])
        {
            Caption = 'Change Reason';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code".Code;
        }
        field(50114; "Original Quote No. S365"; Code[20])
        {
            Caption = 'Original Quote No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50115; "Amend & Archived S365"; Boolean)
        {
            Caption = 'Amend & Archived';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50116; "ConfirmedS365"; Boolean)
        {
            Caption = 'Confirmed';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50117; "Quote Status S365"; Enum "Qoute Status S365")
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Status';
        }
        field(50118; "Job TemplateS365"; Code[20])
        {
            Caption = 'Job No. Template';
            DataClassification = CustomerContent;
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
        field(50127; "End User/ Main Customer"; Text[100])
        {
            Caption = 'End User';
            DataClassification = ToBeClassified;
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
        field(50119; "Service Provider No."; Code[20])
        {
            Caption = 'Service Provider No';
            DataClassification = ToBeClassified;
        }
        field(50120; "4HC Type"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
            //ObsoleteState = Pending;
            //ObsoleteTag = '202509094HC';
        }
        field(50121; "OPCO Customer"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'OPCO Customer';
        }
        field(50131; "G/L Account"; Text[30])
        {
            Caption = 'G/L Account';
        }
        field(50132; "Incoming PO"; Text[30])
        {
            Caption = 'Incoming PO';
        }
        field(50139; "Sales Order No. 4HC"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Order No.';
        }
    }
}
