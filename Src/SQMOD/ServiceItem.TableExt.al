tableextension 50108 ServiceItem extends "Service Item"
{
    fields
    {
        field(50100; GennextWarrantySDParts; Date)
        {
            Caption = 'Gennext Warranty Start Date (Parts)';
            DataClassification = ToBeClassified;
        }
        field(50101; GennextWarrantyEDParts; Date)
        {
            Caption = 'Gennext Warranty End Date (Parts)';
            DataClassification = ToBeClassified;
        }
        field(50102; GennextWarrantyPercParts; Decimal)
        {
            Caption = 'Gennext Warranty % (Parts)';
            DataClassification = ToBeClassified;
            BlankZero = true;
            DecimalPlaces = 0: 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(50103; GennextWarrantySDLabor; Date)
        {
            Caption = 'Gennext Warranty Start Date (Labor)';
            DataClassification = ToBeClassified;
        }
        field(50104; GennextWarrantyEDLabor; Date)
        {
            Caption = 'Gennext Warranty End Date (Labor)';
            DataClassification = ToBeClassified;
        }
        field(50105; GennextWarrantyPercLabor; Decimal)
        {
            Caption = 'Gennext Warranty % (Labor)';
            DataClassification = ToBeClassified;
            BlankZero = true;
            DecimalPlaces = 0: 5;
            MaxValue = 100;
            MinValue = 0;
        }
    }
}
