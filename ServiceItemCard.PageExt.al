pageextension 50114 ServiceItemCard extends "Service Item Card"
{
    layout
    {
        addafter("Warranty % (Labor)")
        {
            field(GennextWarrantySDParts; Rec.GennextWarrantySDParts)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(GennextWarrantyEDParts; Rec.GennextWarrantyEDParts)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(GennextWarrantyPercParts; Rec.GennextWarrantyPercParts)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(GennextWarrantySDLabor; Rec.GennextWarrantySDLabor)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(GennextWarrantyEDLabor; Rec.GennextWarrantyEDLabor)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field(GennextWarrantyPercLabor; Rec.GennextWarrantyPercLabor)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}
