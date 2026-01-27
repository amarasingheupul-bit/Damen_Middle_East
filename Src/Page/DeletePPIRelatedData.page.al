page 50118 "Delete PPI Related Data"
{
    PageType = Card;
    Caption = 'Delete PPI Related Data';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RMID,
                    tabledata "Purch. Inv. Header" = RIMD,
                    tabledata "Purch. Inv. Line" = RIMD,
                    tabledata "Vendor Ledger Entry" = RIMD,
                    tabledata "Detailed Vendor Ledg. Entry" = RIMD,
                    tabledata "VAT Entry" = RIMD,
                    tabledata "Item Ledger Entry" = RIMD,
                    tabledata "Value Entry" = RIMD,
                    tabledata "Excel Data Import General" = RIMD;

    actions
    {
        area(Processing)
        {
            action(UpdateData)
            {
                ApplicationArea = All;
                ToolTip = 'Tool Tip';
                Image = Process;

                trigger OnAction()
                begin
                    this.ExcelData.SetRange("Entry No.", 1, 1000);
                    if this.ExcelData.FindFirst() then
                        repeat

                            // 01-Delete G/L Entries
                            this.GL.Reset();
                            this.GL.SetFilter(this.GL."Document No.", '%1', this.ExcelData."Document No.");

                            if this.GL.FindFirst() then
                                Message('GL Document No.: %1', this.GL."Document No.");

                            repeat
                                this.gl.Delete();
                                Message('Deleting Document No.: %1', this.GL."Document No.");

                            until this.GL.Next() = 0;

                            // 02-Delete VAT Entries

                            this.VATE.Reset();
                            this.VATE.SetFilter(this.VATE."Document No.", '%1', this.ExcelData."Document No.");

                            if this.VATE.FindFirst() then
                                repeat
                                    this.VATE.Delete();
                                until this.VATE.Next() = 0;

                            // 03-Delete Vendor Ledger Entries

                            this.VLE.Reset();
                            this.VLE.SetFilter(this.VLE."Document No.", '%1', this.ExcelData."Document No.");

                            if this.VLE.FindFirst() then
                                repeat
                                    this.VLE.Delete();
                                until this.VLE.Next() = 0;

                            // 04-Delete Detailed Vendor Ledger Entries

                            this.DVLE.Reset();
                            this.DVLE.SetFilter(this.DVLE."Document No.", '%1', this.ExcelData."Document No.");

                            if this.DVLE.FindFirst() then
                                repeat
                                    this.DVLE.Delete();
                                until this.DVLE.Next() = 0;

                            // 05-Delete Item Ledger Entries

                            this.ILE.Reset();
                            this.ILE.SetFilter(this.ILE."Document No.", '%1', this.ExcelData."Document No.");

                            if this.ILE.FindFirst() then
                                repeat
                                    this.ILE.Delete();
                                until this.ILE.Next() = 0;

                            // 06-Delete Value Entries

                            this.VALE.Reset();
                            this.VALE.SetFilter(this.VALE."Document No.", '%1', this.ExcelData."Document No.");

                            if this.VALE.FindFirst() then
                                repeat
                                    this.VALE.Delete();
                                until this.VALE.Next() = 0;

                            // 07-Delete Purch. Inv. Line Records with matching Document No.

                            this.PINVLINE.Reset();
                            this.PINVLINE.SetFilter(this.PINVLINE."Document No.", '%1', this.ExcelData."Document No.");

                            if this.PINVLINE.FindFirst() then
                                repeat
                                    this.PINVLINE.Delete();
                                until this.PINVLINE.Next() = 0;

                            // 08-Delete Purch. Inv. Header Records with matching Document No.

                            this.PINVHDR.Reset();
                            this.PINVHDR.SetFilter(this.PINVHDR."No.", '%1', this.ExcelData."Document No.");

                            if this.PINVHDR.FindFirst() then
                                repeat
                                    this.PINVHDR.Delete();
                                until this.PINVHDR.Next() = 0;

                        until this.ExcelData.Next() = 0;

                    Message('Process Finished');

                end;
            }
        }

    }
    var
        ExcelData: Record "Excel Data Import General";
        GL: Record "G/L Entry";
        VLE: Record "Vendor Ledger Entry";
        DVLE: Record "Detailed Vendor Ledg. Entry";
        PINVHDR: Record "Purch. Inv. Header";
        PINVLINE: Record "Purch. Inv. Line";
        VATE: Record "VAT Entry";
        ILE: Record "Item Ledger Entry";
        VALE: Record "Value Entry";
}