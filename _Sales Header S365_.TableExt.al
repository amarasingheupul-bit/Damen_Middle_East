tableextension 50100 "Sales Header S365" extends "Sales Header"
{
    fields
    {
        field(50100; "Origin S365"; Text[50])
        {
            Caption = 'Origin';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Origin));
            ValidateTableRelation = false;
        }
        field(50101; "Destination S365"; Text[50])
        {
            Caption = 'Destination';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Destination));
            ValidateTableRelation = false;
        }
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
        field(50104; "Printed or Email S365"; Boolean)
        {
            Caption = 'Printed or Email';
            DataClassification = CustomerContent;
            Editable = false;
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
        field(50108; "Job TemplateS365"; Code[20])
        {
            Caption = 'Job No. Template';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50109; "Quote Status S365"; Enum "Qoute Status S365")
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Status';
        }
        field(50110; "ETD S365"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'ETD';
        }
        field(50111; "ETA S365"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'ETA';
        }
        field(50112; "MAWB No. S365"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'MAWB No.';
        }
        field(50113; "MAWB Date S365"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'MAWB Date';
        }
        field(50114; "Cross Trade S365"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cross Trade';
        }
        field(50115; "Container No. S365"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Container No.';
        }
        field(50116; "Remarks S365"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
        field(50117; "Job No. S365"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No';
            Editable = false;
        }
        field(50118; "Place of Receipt S365"; Text[50])
        {
            Caption = 'Place of Receipt';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Origin));
            ValidateTableRelation = false;
        }
        field(50119; "Place of Delivery S365"; Text[50])
        {
            Caption = 'Place of Delivery';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Destination));
            ValidateTableRelation = false;
        }
        field(50120; "Carrier"; Text[50])
        {
            Caption = 'Carrier';
            DataClassification = CustomerContent;
        }
        field(50121; "Delivery Instructions"; Text[100])
        {
            Caption = 'Delivery Instructions';
            DataClassification = CustomerContent;
        }
        // Feb. 13 2025
        field(50122; "Sales Derector/ Area Director"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Dimension".Code where(Blocked = const(false));
            //TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7), Blocked=const(false));
            TableRelation = "Salesperson/Purchaser".Code;
            trigger OnValidate()
            var
                Salesperson: Record "Salesperson/Purchaser";
            begin
                if Salesperson.Get("Sales Derector/ Area Director") then
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
        }
        field(50123; "Sales Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50124; "Sales Contract Desc"; Text[100])
        {
            DataClassification = ToBeClassified;
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
        }
        field(50130; "Sales Area"; Code[20])
        {
            DataClassification = ToBeClassified;
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
    trigger OnBeforeModify()
    var
        Text000Err: Label 'Modification is restricted. This document was printed or sent by email.';
    begin
        if (Rec."Document Type" = Rec."Document Type"::Quote) and Rec."Printed or Email S365" and (xRec."Printed or Email S365" = Rec."Printed or Email S365") then Error(Text000Err);
    end;
}
