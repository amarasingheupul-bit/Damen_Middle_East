page 50110 "Vendor Confirmation Dialog"
{
    PageType = Card;
    Caption = 'Vendor Purchase Order Confirmation';
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group1)
            {
                ShowCaption = false;
                field("Vendor"; VendorCode)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor';
                    ToolTip = 'Specifies the vendor to whom the purchase order is sent.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendorRec: Record Vendor;
                    begin
                        VendorRec.Reset();
                        if Page.RunModal(Page::"Vendor Lookup", VendorRec) = Action::LookupOK then
                            VendorCode := VendorRec."No.";
                    end;
                }
                field("Open Purchase Orders"; OpenPurchaseOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Open Purchase Orders';
                    ToolTip = 'Select a purchase order to link to this job.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PurchaseOrderRec: Record "Purchase Header";
                    begin
                        PurchaseOrderRec.SetRange("Document Type", PurchaseOrderRec."Document Type"::Order);
                        PurchaseOrderRec.SetRange("Buy-from Vendor No.", VendorCode);
                        PurchaseOrderRec.SetFilter("Status", '%1|%2', PurchaseOrderRec."Status"::Open, PurchaseOrderRec."Status"::Released);
                        if Page.RunModal(Page::"Purchase List", PurchaseOrderRec) = Action::LookupOK then
                            OpenPurchaseOrder := PurchaseOrderRec."No.";
                    end;
                }
            }
        }
    }

    var
        VendorCode: Code[20];
        OpenPurchaseOrder: Code[20];

    procedure GetVendorCode(): Code[20]
    begin
        exit(VendorCode);
    end;

    procedure GetPurchaseOrderNo(): Code[20]
    begin
        exit(OpenPurchaseOrder);
    end;
}