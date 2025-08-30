tableextension 50114 "4HC PurchInvEntityAggregate" extends "Purch. Inv. Entity Aggregate"
{
    fields
    {
        field(50101; "OPCO Com Project No."; Code[50])
        {
            Caption = 'OPCO Com Project No.';
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
        field(50106; "Vessel Type"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Type';
        }
        field(50109; "Email Approval Status"; Enum "4HC PAutoApprovalStatus")
        {
            DataClassification = ToBeClassified;
            Caption = 'Email Approval Status';
        }
        field(50110; "External Approver 1 Email"; Text[80])
        {
            Caption = 'External Approver 1 Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser"."E-Mail" where(Code = field("Purchaser Code")));
        }
        field(50112; "External Approver 2 Email"; Text[80])
        {
            Caption = 'External Approver 2 Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser"."E-Mail" where(Code = field("External Approver 2 No.")));
        }
        field(50111; "Approval Rejection Reason"; Text[250])
        {
            Caption = 'Approval Rejection Reason';
            DataClassification = CustomerContent;
        }
        field(50133; "External Approver 2 No."; Code[20])
        {
            Caption = 'External Approver 2 No.';
            TableRelation = "Salesperson/Purchaser".Code;
        }
    }
}