tableextension 50110 "4HC Purchase Header" extends "Purchase Header"
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
    }
}
