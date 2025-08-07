report 50101 "Air Freight Arrival Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Src/Report/Layout/Air Freight Arrival Receipt.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")where("Document Type"=const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.";

            column(TaglineCaptionLbl;this.TaglineCaptionLbl)
            {
            }
            column(AirfteightCaptionLbl;this.AirfteightCaptionLbl)
            {
            }
            column(ShipmentNoCaptionLbl;this.ShipmentNoCaptionLbl)
            {
            }
            column(JobNoCaptionLbl;this.JobNoCaptionLbl)
            {
            }
            column(ShipmentDateCaptionLbl;this.ShipmentDateCaptionLbl)
            {
            }
            column(ShipmentDetailCaptionLbl;this.ShipmentDetailCaptionLbl)
            {
            }
            column(ShipperCaptionLbl;this.ShipperCaptionLbl)
            {
            }
            column(ConsigneeCaptionLbl;this.ConsigneeCaptionLbl)
            {
            }
            column(PickupCaptionLbl;this.PickupCaptionLbl)
            {
            }
            column(DeliverToCaptionLbl;this.DeliverToCaptionLbl)
            {
            }
            column(RountingInfoCaptionLbl;this.RountingInfoCaptionLbl)
            {
            }
            column(OriginCaptionLbl;this.OriginCaptionLbl)
            {
            }
            column(ETDCaptionLbl;this.ETDCaptionLbl)
            {
            }
            column(DestinationCaptionLbl;this.DestinationCaptionLbl)
            {
            }
            column(ETACaptionLbl;this.ETACaptionLbl)
            {
            }
            column(CarrierCaptionLbl;this.CarrierCaptionLbl)
            {
            }
            column(OrderNumberReferenceCaptionLbl;this.OrderNumberReferenceCaptionLbl)
            {
            }
            column(GoodsDescriptionCaptionLbl;this.GoodsDescriptionCaptionLbl)
            {
            }
            column(MAWBCaptionLbl;this.MAWBCaptionLbl)
            {
            }
            column(HAWBCaptionLbl;this.HAWBCaptionLbl)
            {
            }
            column(PackagesCaptionLbl;this.PackagesCaptionLbl)
            {
            }
            column(WeightCaptionLbl;this.WeightCaptionLbl)
            {
            }
            column(VolumeCaptionLbl;this.VolumeCaptionLbl)
            {
            }
            column(ChargeableCaptionLbl;this.ChargeableCaptionLbl)
            {
            }
            column(CommodityCaptionLbl;this.CommodityCaptionLbl)
            {
            }
            column(HandlingDeliveryCaptionLbl;this.HandlingDeliveryCaptionLbl)
            {
            }
            column(HandlingDeliveryLbl;this.HandlingDeliveryLbl)
            {
            }
            column(SignatureCaptionLbl;this.SignatureCaptionLbl)
            {
            }
            column(DateCaptionLbl;this.DateCaptionLbl)
            {
            }
            column(TimeTruckInCaptionLbl;this.TimeTruckInCaptionLbl)
            {
            }
            column(NameCaptionLbl;this.NameCaptionLbl)
            {
            }
            column(TimeTruckOutCaptionLbl;this.TimeTruckOutCaptionLbl)
            {
            }
            column(ReceivedInGoodOrderCaptionLbl;this.ReceivedInGoodOrderCaptionLbl)
            {
            }
            column(PrintedByCaptionLbl;this.PrintedByCaptionLbl)
            {
            }
            column(PrintedDateCaptionLbl;this.PrintedDateCaptionLbl)
            {
            }
            column(SalesHeader_No; "No.")
            {
            }
            column(SalesHeader_ShipmentDate; "Shipment Date")
            {
            }
            column(SalesHeader_Comment; Comment)
            {
            }
            column(SalesHeader_ShiptoName; "Ship-to Name")
            {
            }
            column(SalesHeader_Origin_S365; "Origin S365")
            {
            }
            column(SalesHeader_ETD_S365; "ETD S365")
            {
            }
            column(SalesHeader_Destination_S365; "Destination S365")
            {
            }
            column(SalesHeader_ETA_S365; "ETA S365")
            {
            }
            column(SalesHeader_MAWB_No__S365; "MAWB No. S365")
            {
            }
            column(SalesHeader_Job_No__S365; "Job No. S365")
            {
            }
            column(SalesHeader_Work_Description; "Work Description")
            {
            }
            column(SalesHeader_Carrier; Carrier)
            {
            }
            column(SalesHeader_External_Document_No_; "External Document No.")
            {
            }
            column(SalesHeader_Delivery_Instructions; "Delivery Instructions")
            {
            }
            column(SalesHeader_Ship_to_Name; "Ship-to Name")
            {
            }
            column(CompAddr1;this.CompanyAddr[1])
            {
            }
            column(CompAddr2;this.CompanyAddr[2])
            {
            }
            column(CompAddr3;this.CompanyAddr[3])
            {
            }
            column(CompAddr4;this.CompanyAddr[4])
            {
            }
            column(CompAddr5;this.CompanyAddr[5])
            {
            }
            column(CompAddr6;this.CompanyAddr[6])
            {
            }
            column(CompAddr7;this.CompanyAddr[7])
            {
            }
            column(CompAddr8;this.CompanyAddr[8])
            {
            }
            column(CustAddr_1;this.CustAddr[1])
            {
            }
            column(CustAddr_2;this.CustAddr[2])
            {
            }
            column(CustAddr_3;this.CustAddr[3])
            {
            }
            column(CustAddr_4;this.CustAddr[4])
            {
            }
            column(CustAddr_5;this.CustAddr[5])
            {
            }
            column(CustAddr_6;this.CustAddr[6])
            {
            }
            column(CustAddr_7;this.CustAddr[7])
            {
            }
            column(CustAddr_8;this.CustAddr[8])
            {
            }
            column(ShipToAddr1;this.ShipToAddr[1])
            {
            }
            column(ShipToAddr2;this.ShipToAddr[2])
            {
            }
            column(ShipToAddr3;this.ShipToAddr[3])
            {
            }
            column(ShipToAddr4;this.ShipToAddr[4])
            {
            }
            column(ShipToAddr5;this.ShipToAddr[5])
            {
            }
            column(ShipToAddr6;this.ShipToAddr[6])
            {
            }
            column(ShipToAddr7;this.ShipToAddr[7])
            {
            }
            column(ShipToAddr8;this.ShipToAddr[8])
            {
            }
            column(CompanyInformation_Picture;this.CompanyInformation.Picture)
            {
            }
            column(CompanyInformation_Name;this.CompanyInformation.Name)
            {
            }
            column(CompanyInformation_City;this.CompanyInformation.City)
            {
            }
            column(CompanyInformation_PhoneNo;this.CompanyInformation."Phone No.")
            {
            }
            column(CompanyInformation_FaxNo;this.CompanyInformation."Fax No.")
            {
            }
            column(CompanyInformation_HomePage;this.CompanyInformation."Home Page")
            {
            }
            column(CompanyInformation_EMail;this.CompanyInformation."E-Mail")
            {
            }
            column(CompanyInformation_VATRegistrationNo;this.CompanyInformation."VAT Registration No.")
            {
            }
            column(Customer_Name;this.Customer.Name)
            {
            }
            column(Customer_Address;this.Customer.Address)
            {
            }
            column(Customer_Address2;this.Customer."Address 2")
            {
            }
            column(Customer_City;this.Customer.City)
            {
            }
            column(Customer_Contact;this.Customer.Contact)
            {
            }
            column(Customer_PhoneNo;this.Customer."Phone No.")
            {
            }
            column(Location_Name;this.Location.Name)
            {
            }
            column(Location_Address;this.Location.Address)
            {
            }
            column(Location_Address2;this.Location."Address 2")
            {
            }
            column(Location_City;this.Location.City)
            {
            }
            column(Location_PhoneNo;this.Location."Phone No.")
            {
            }
            column(Location_FaxNo;this.Location."Fax No.")
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemLinkReference = "Sales Header";
                DataItemTableView = sorting("Document No.", "Line No.");

                column(SalesLine_Description; Description)
                {
                }
                column(SalesLine_Quantity; Quantity)
                {
                }
                column(SalesLine_Total_Weight_S365; "Total Weight S365")
                {
                }
                column(SalesLine_Volume_S365; "Volume S365")
                {
                }
                column(SalesLine_Volume_Weight_S365; "Volume Weight S365")
                {
                }
                column(SalesLine_Commodity; Commodity)
                {
                }
            }
            trigger OnAfterGetRecord()
            begin
                if not this.Customer.Get("Sell-to Customer No.")then Clear(this.Customer);
                if not Location.Get("Location Code")then Clear(Location);
                this.FormatAddr.GetCompanyAddr("Responsibility Center", this.RespCenter, this.CompanyInformation, this.CompanyAddr);
                this.FormatAddr.SalesHeaderSellTo(this.CustAddr, "Sales Header");
                this.FormatAddr.SalesHeaderShipTo(this.ShipToAddr, this.CustAddr, "Sales Header");
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        this.CompanyInformation.Get();
        this.CompanyInformation.CalcFields(Picture);
    end;
    var CompanyInformation: Record "Company Information";
    Customer: Record Customer;
    Location: Record Location;
    RespCenter: Record "Responsibility Center";
    FormatAddr: Codeunit "Format Address";
    TaglineCaptionLbl: Label 'Your prompt payment records contribute towards building a positive credit profile for your company';
    AirfteightCaptionLbl: Label 'AIR FREIGHT ARRIVAL CARTAGE ADVICE WITH RECEIPT';
    ShipmentNoCaptionLbl: Label 'SHIPMENT No.';
    JobNoCaptionLbl: Label 'JOB No.';
    ShipmentDateCaptionLbl: Label 'SHIPMENT DATE';
    ShipmentDetailCaptionLbl: Label 'SHIPMANT DETAILS';
    ShipperCaptionLbl: Label 'SHIPPER';
    ConsigneeCaptionLbl: Label 'CONSIGNEE';
    PickupCaptionLbl: Label 'PICKUP';
    DeliverToCaptionLbl: Label 'DELIVER TO';
    RountingInfoCaptionLbl: Label 'ROUTING INFORMATION';
    OriginCaptionLbl: Label 'Origin';
    ETDCaptionLbl: Label 'ETD';
    DestinationCaptionLbl: Label 'DESTINATION';
    ETACaptionLbl: Label 'ETA';
    CarrierCaptionLbl: Label 'CARRIER';
    OrderNumberReferenceCaptionLbl: Label 'ORDER NUMBERS / REFERENCE';
    GoodsDescriptionCaptionLbl: Label 'GOODS DESCRIPTION';
    MAWBCaptionLbl: Label 'MAWB';
    HAWBCaptionLbl: Label 'HAWB';
    PackagesCaptionLbl: Label 'PACKAGES';
    WeightCaptionLbl: Label 'WEIGHT';
    VolumeCaptionLbl: Label 'VOLUME';
    ChargeableCaptionLbl: Label 'CHARGEABLE';
    CommodityCaptionLbl: Label 'COMMODITY';
    HandlingDeliveryCaptionLbl: Label 'HANDLING/DELIVERY INSTRUCTION';
    HandlingDeliveryLbl: Label 'AIR IMPORT FOR MV ONE OCEAN ON 23/10/24 FROM SATS TO RIO WSHE. KINDLY ASSIST TO CLEAR ON 23rd OCT FROM SATS TO RIO WSHE. ';
    ReceivedInGoodOrderCaptionLbl: Label 'RECEIVED IN GOOD ORDER AND CONDITION';
    SignatureCaptionLbl: Label 'Signature:';
    DateCaptionLbl: Label 'Date:';
    TimeTruckInCaptionLbl: Label 'Time Truck In:';
    NameCaptionLbl: Label 'Name:';
    TimeTruckOutCaptionLbl: Label 'Time Truck Out:';
    PrintedByCaptionLbl: Label 'PRINTED BY:';
    PrintedDateCaptionLbl: Label 'Printed Date:';
    CompanyAddr: array[8]of Text[100];
    CustAddr: array[8]of Text[100];
    ShipToAddr: array[8]of Text[100];
}
