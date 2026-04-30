report 50117 "Update Project Dimension"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;
    Caption = 'Update Project Dimension';

    Permissions =
        tabledata "Purch. Inv. Header" = RIMD,
        tabledata "Purch. Inv. Line" = RIMD,
        tabledata "G/L Entry" = RIMD,
        tabledata "Vendor Ledger Entry" = RIMD,
        tabledata "Item Ledger Entry" = RIMD;

    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(PurchInvNo; PurchInvNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Posted Purchase Invoice No.';
                        TableRelation = "Purch. Inv. Header"."No.";
                    }

                    field(ProjectCode; ProjectCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Project Code';
                        TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('PROJECT'));
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if PurchInvNo = '' then
            Error('Please enter Posted Purchase Invoice No.');

        if ProjectCode = '' then
            Error('Please enter Project Code.');

        if not DimValue.Get('PROJECT', ProjectCode) then
            Error('Invalid Project Dimension Value: %1', ProjectCode);

        UpdatePurchInvoice();
        UpdateGLEntries();
        UpdateVendorLedger();
        UpdateItemLedger();

        Message('Project Dimension updated successfully.');
    end;

    var
        PurchInvNo: Code[20];
        ProjectCode: Code[20];
        DimMgt: Codeunit DimensionManagement;
        DimValue: Record "Dimension Value";

    // =============================
    // Purchase Invoice Update
    // =============================
    local procedure UpdatePurchInvoice()
    var
        Header: Record "Purch. Inv. Header";
        Line: Record "Purch. Inv. Line";
        NewDimSetID: Integer;
    begin
        Header.LockTable();

        if not Header.Get(PurchInvNo) then
            Error('Posted Purchase Invoice not found.');

        NewDimSetID := GetUpdatedDimSetID(Header."Dimension Set ID");
        Header."Dimension Set ID" := NewDimSetID;
        // Purch. Inv. Header uses Shortcut Dimension fields — update them directly
        UpdateShortcutDims(NewDimSetID, Header."Shortcut Dimension 1 Code", Header."Shortcut Dimension 2 Code");
        if not Header.Modify(false) then
            Error('Failed to update Purchase Invoice Header: %1', PurchInvNo);

        Line.LockTable();
        Line.SetRange("Document No.", PurchInvNo);
        if Line.FindSet(true, false) then
            repeat
                NewDimSetID := GetUpdatedDimSetID(Line."Dimension Set ID");
                Line."Dimension Set ID" := NewDimSetID;
                // Purch. Inv. Line uses Shortcut Dimension fields — update them directly
                UpdateShortcutDims(NewDimSetID, Line."Shortcut Dimension 1 Code", Line."Shortcut Dimension 2 Code");
                if not Line.Modify(false) then
                    Error('Failed to update Purchase Invoice Line: %1', Line."Line No.");
            until Line.Next() = 0;
    end;

    // =============================
    // G/L Entries
    // =============================
    local procedure UpdateGLEntries()
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.LockTable();
        GLEntry.SetRange("Document No.", PurchInvNo);
        GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);

        if GLEntry.FindSet(true, false) then
            repeat
                GLEntry."Dimension Set ID" := GetUpdatedDimSetID(GLEntry."Dimension Set ID");
                DimMgt.UpdateGlobalDimFromDimSetID(
                    GLEntry."Dimension Set ID",
                    GLEntry."Global Dimension 1 Code",
                    GLEntry."Global Dimension 2 Code"
                );
                if not GLEntry.Modify(false) then
                    Error('Failed to update G/L Entry: %1', GLEntry."Entry No.");
            until GLEntry.Next() = 0;
    end;

    // =============================
    // Vendor Ledger Entry
    // =============================
    local procedure UpdateVendorLedger()
    var
        VendLedg: Record "Vendor Ledger Entry";
    begin
        VendLedg.LockTable();
        VendLedg.SetRange("Document No.", PurchInvNo);
        VendLedg.SetRange("Document Type", VendLedg."Document Type"::Invoice);

        if VendLedg.FindSet(true, false) then
            repeat
                VendLedg."Dimension Set ID" := GetUpdatedDimSetID(VendLedg."Dimension Set ID");
                DimMgt.UpdateGlobalDimFromDimSetID(
                    VendLedg."Dimension Set ID",
                    VendLedg."Global Dimension 1 Code",
                    VendLedg."Global Dimension 2 Code"
                );
                if not VendLedg.Modify(false) then
                    Error('Failed to update Vendor Ledger Entry: %1', VendLedg."Entry No.");
            until VendLedg.Next() = 0;
    end;

    // =============================
    // Item Ledger Entry
    // =============================
    local procedure UpdateItemLedger()
    var
        ItemLedg: Record "Item Ledger Entry";
    begin
        ItemLedg.LockTable();
        ItemLedg.SetRange("Document No.", PurchInvNo);

        if ItemLedg.FindSet(true, false) then
            repeat
                ItemLedg."Dimension Set ID" := GetUpdatedDimSetID(ItemLedg."Dimension Set ID");
                DimMgt.UpdateGlobalDimFromDimSetID(
                    ItemLedg."Dimension Set ID",
                    ItemLedg."Global Dimension 1 Code",
                    ItemLedg."Global Dimension 2 Code"
                );
                if not ItemLedg.Modify(false) then
                    Error('Failed to update Item Ledger Entry: %1', ItemLedg."Entry No.");
            until ItemLedg.Next() = 0;
    end;

    // =============================
    // Shortcut Dimension Update
    // (for Purch. Inv. Header & Line which use Shortcut fields)
    // =============================
    local procedure UpdateShortcutDims(DimSetID: Integer; var ShortcutDim1: Code[20]; var ShortcutDim2: Code[20])
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        if not GLSetup.Get() then
            exit;

        // Reset first
        ShortcutDim1 := '';
        ShortcutDim2 := '';

        // Shortcut Dim 1
        if GLSetup."Global Dimension 1 Code" <> '' then
            if DimSetEntry.Get(DimSetID, GLSetup."Global Dimension 1 Code") then
                ShortcutDim1 := DimSetEntry."Dimension Value Code";

        // Shortcut Dim 2
        if GLSetup."Global Dimension 2 Code" <> '' then
            if DimSetEntry.Get(DimSetID, GLSetup."Global Dimension 2 Code") then
                ShortcutDim2 := DimSetEntry."Dimension Value Code";
    end;

    // =============================
    // Dimension Logic
    // =============================
    local procedure GetUpdatedDimSetID(OldDimSetID: Integer): Integer
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry, OldDimSetID);

        TempDimSetEntry.SetRange("Dimension Code", 'PROJECT');
        if TempDimSetEntry.FindFirst() then
            TempDimSetEntry.Delete();
        TempDimSetEntry.Reset();

        TempDimSetEntry.Init();
        TempDimSetEntry."Dimension Code" := DimValue."Dimension Code";
        TempDimSetEntry."Dimension Value Code" := DimValue.Code;
        TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
        TempDimSetEntry.Insert();

        exit(DimMgt.GetDimensionSetID(TempDimSetEntry));
    end;
}