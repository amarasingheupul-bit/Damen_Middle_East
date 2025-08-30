pageextension 50100 "4HC Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("REF SAP ID"; Rec."REF SAP ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the SAP ID reference used for this vendor.';
            }
            field("REF IFS ID"; Rec."REF IFS ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the IFS ID reference used for this vendor.';
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Shows the date when this vendor record was created or imported.';
            }
            field("DUNS No."; Rec."DUNS No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the DUNS No. field.';
            }
        }
    }
}
