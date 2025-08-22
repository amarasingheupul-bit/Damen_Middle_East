tableextension 50102 "Sales Line S365" extends "Sales Line"
{
    fields
    {
        field(50100; "Printed or Email S365"; Boolean)
        {
            Caption = 'Printed or Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Printed or Email S365" where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50102; "Package Type S365"; Code[10])
        {
            Caption = 'Package Type';
            DataClassification = CustomerContent;
            TableRelation = PackageTypeS365.Code;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';
        }
        field(50103; "WidthS365"; Decimal)
        {
            Caption = 'Width(CM)';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';

            // trigger OnValidate()
            // begin
            //     //this.CalcNetWeight();
            //     this.CalculateVolume();
            //     this.CalculateVolumeWeight();  
            //     this.CalculateTotalWeight();
            // end;
        }
        field(50104; "HeightS365"; Decimal)
        {
            Caption = 'Height(CM)';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';

            // trigger OnValidate()
            // begin
            //     //this.CalcNetWeight();
            //     this.CalculateVolume();
            //     this.CalculateVolumeWeight();
            //     this.CalculateTotalWeight();
            // end;
        }
        field(50105; "LengthS365"; Decimal)
        {
            Caption = 'Length(CM)';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';

            // trigger OnValidate()
            // begin
            //     //this.CalcNetWeight();
            //     this.CalculateVolume();
            //     this.CalculateVolumeWeight();
            //     this.CalculateTotalWeight();
            // end;
        }
        field(50106; "No. of Packages S365"; Decimal)
        {
            Caption = 'No. of Packages';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';
        }
        field(50107; "No. of Pallets S365"; Decimal)
        {
            Caption = 'No. of Pallets';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';
        }
        field(50108; "Volume S365"; Decimal)
        {
            Caption = 'Volume';
            DataClassification = CustomerContent;
            Editable = false;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';
        }
        field(50109; "Volume Weight S365"; Decimal)
        {
            Caption = 'Volume Weight';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 5;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';
        }
        field(50110; "Total Weight S365"; Decimal)
        {
            Caption = 'Total Weight';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 5;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';
        }
        field(50111; "HS Code S365"; Code[20])
        {
            Caption = 'HS Code';
            DataClassification = CustomerContent;
            ObsoleteReason = 'Not used anymore';
            ObsoleteState = Pending;
            ObsoleteTag = '20250508';
        }
        field(50112; "Commodity"; Option)
        {
            Caption = 'Commodity';
            OptionMembers = GEN;
            DataClassification = CustomerContent;
        }
    }
    trigger OnBeforeModify()
    var
        Text000Err: Label 'Modification is restricted. This document was printed or sent by email.';
    begin
        Rec.CalcFields("Printed or Email S365");
        if (Rec."Document Type" = Rec."Document Type"::Quote) and Rec."Printed or Email S365" then Error(Text000Err);
    end;
    // local procedure CalcNetWeight()
    // begin
    //     "Net Weight":=WidthS365 * HeightS365 * LengthS365;
    //     rec.Modify();
    // end;
    // procedure CalculateVolume()
    // begin
    //     "Volume S365":=HeightS365 * LengthS365 * WidthS365;
    // end;
    // procedure CalculateVolumeWeight()
    // begin
    //     "Volume Weight S365":="Volume S365" / 6000;
    // end;
    // procedure CalculateTotalWeight()
    // begin
    //     "Total Weight S365":="Net Weight" + "Volume Weight S365";
    // end;
}
