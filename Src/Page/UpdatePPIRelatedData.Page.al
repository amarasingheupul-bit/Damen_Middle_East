#pragma warning disable AA0215
page 50113 "Update PPI Fields"
#pragma warning restore AA0215

{
    PageType = Card;
    Caption = 'Update PPI Related Data All files';
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
                    tabledata "FA Ledger Entry" = RIMD,
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
                        this.EntryNoInt := this.ExcelData."Entry##";


                    repeat

                        // Update GL Entry-------------------------------------------------
                        this.GL.Reset();
                        this.GL.SetFilter(this.GL."Document No.", '%1', this.ExcelData."Document No.");
                        if this.GL.FindFirst() then
                            repeat
                                if this.EntryNoInt <> 0 then
                                    if this.GL."Entry No." = this.EntryNoInt then begin

                                        if this.ExcelData.UpdateField = 'G/LAccountNo' then
                                            this.GL."G/L Account No." := this.ExcelData."Value 3";

                                        if this.ExcelData.UpdateField = 'Amount' then begin
                                            this.GL.Amount := this.ExcelData."Value 2";
                                            this.GL."Debit Amount" := 0;
                                            this.GL."Credit Amount" := 0;

                                            if this.ExcelData."Value 2" > 0 then
                                                this.GL."Debit Amount" := this.ExcelData."Value 2";

                                            if this.ExcelData."Value 2" < 0 then
                                                this.GL."Credit Amount" := this.ExcelData."Value 2";

                                        end;

                                        if this.ExcelData.UpdateField = 'PostDate' then
                                            evaluate(this.GL."Posting Date", this.ExcelData."Value 3");

                                        this.GL.Modify(true);
                                        exit;

                                    end
                                    else

                                        if this.ExcelData.UpdateField = 'PostDate' then
                                            evaluate(this.GL."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.GL."Document No.", this.ExcelData."Value 4");


                                this.GL.Modify(true);


                            until this.GL.Next() = 0;

                        // Update VAT Entry-------------------------------------------------


                        this.VATE.Reset();
                        this.VATE.SetFilter(this.VATE."Document No.", '%1', this.ExcelData."Document No.");

                        if this.VATE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'Amount' then begin

                                    if this.VATE.Base > 0 then begin
                                        this.VATE.Base := this.ExcelData."Value 2" * -1;
                                        this.VATE."Base Before Pmt. Disc." := this.ExcelData."Value 2" * -1;
                                    end;
                                    if this.VATE.Base < 0 then begin
                                        this.VATE.Base := this.ExcelData."Value 2";
                                        this.VATE."Base Before Pmt. Disc." := this.ExcelData."Value 2";
                                    end;

                                end;

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.VATE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.VATE."Document No.", this.ExcelData."Value 4");


                                this.VATE.Modify();

                            until this.VATE.Next() = 0;

                        // Update Vendor Ledger Entry-------------------------------------------------

                        this.VLE.Reset();
                        this.VLE.SetFilter(this.VLE."Document No.", '%1', this.ExcelData."Document No.");

                        if this.VLE.FindFirst() then
                            repeat


                                if this.ExcelData.UpdateField = 'Amount' then begin

                                    this.VLE."Original Amt. (LCY)" := this.ExcelData."Value 2";
                                    this.VLE."Amount (LCY)" := this.ExcelData."Value 2";
                                    this.VLE."Purchase (LCY)" := this.ExcelData."Value 2";

                                    this.VLE."Debit Amount (LCY)" := 0;
                                    this.VLE."Credit Amount (LCY)" := 0;

                                    if this.ExcelData."Value 2" > 0 then
                                        this.VLE."Debit Amount (LCY)" := this.ExcelData."Value 2"
                                    else
                                        this.VLE."Credit Amount (LCY)" := this.ExcelData."Value 2";

                                end;

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.VLE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.VLE."Document No.", this.ExcelData."Value 4");


                                this.VLE.Modify();

                            until this.VLE.Next() = 0;

                        this.DVLE.Reset();
                        this.DVLE.SetFilter(this.DVLE."Document No.", '%1', this.ExcelData."Document No.");
                        if this.DVLE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.DVLE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.DVLE."Document No.", this.ExcelData."Value 4");


                                this.DVLE.Modify();
                            until this.DVLE.Next() = 0;



                        this.ILE.Reset();
                        this.ILE.SETRANGE(this.ILE."Entry Type", this.ILE."Entry Type"::Purchase);
                        this.ILE.SetFilter(this.ILE."Document No.", '%1', this.ExcelData."Document No.");

                        if this.ILE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.ILE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.ILE."Document No.", this.ExcelData."Value 4");


                                this.ILE.Modify();
                            until this.ILE.Next() = 0;


                        this.VALE.Reset();
                        this.VALE.SETRANGE(this.VALE."Item Ledger Entry Type", this.VALE."Item Ledger Entry Type"::Purchase);
                        this.VALE.SetFilter(this.VALE."Document No.", '%1', this.ExcelData."Document No.");


                        if this.VALE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.VALE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.VALE."Document No.", this.ExcelData."Value 4");


                                this.VALE.Modify();
                            until this.VALE.Next() = 0;


                        this.PINVLINE.Reset();
                        this.PINVLINE.SetFilter(this.PINVLINE."Document No.", '%1', this.ExcelData."Document No.");

                        if this.PINVLINE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.PINVLINE."Posting Date", this.ExcelData."Value 3");

                                this.TempPINVLINE.Reset();
                                if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                    // Create temporary copy of the record
                                    this.TempPINVLINE := this.PINVLINE;
                                    this.PINVLINE.Delete();
                                    this.PINVLINE := this.TempPINVLINE;
                                    this.PINVLINE."Document No." := this.ExcelData."Value 4";
                                    this.PINVLINE.Insert();
                                end;

                            until this.PINVLINE.Next() = 0;


                        this.PINVHDR.Reset();
                        this.PINVHDR.SetFilter(this.PINVHDR."No.", '%1', this.ExcelData."Document No.");

                        if this.PINVHDR.FindFirst() then begin


                            if this.ExcelData.UpdateField = 'PostDate' then
                                evaluate(this.PINVHDR."Posting Date", this.ExcelData."Value 3");


                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                // Create temporary copy of the record
                                this.TempPINVHDR := this.PINVHDR;

                                // Delete old record
                                this.PINVHDR.Delete();

                                // Create new record with new doc number
                                this.PINVHDR := this.TempPINVHDR;
                                this.PINVHDR."No." := this.ExcelData."Value 4";
                                this.PINVHDR.Insert();


                            end;

                        end;





                        this.FALE.Reset();
                        this.FALE.SetFilter(this.FALE."Document No.", '%1', this.ExcelData."Document No.");
                        if this.FALE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.FALE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.FALE."Document No.", this.ExcelData."Value 4");

                                this.FALE.Modify();
                            until this.FALE.Next() = 0;

                    until this.ExcelData.Next() = 0;


                    Message('Process Finished');
                end;



            }

        }
    }

    var

        TempPINVHDR: Record "Purch. Inv. Header" temporary;
        TempPINVLINE: Record "Purch. Inv. Line" temporary;
        ExcelData: Record "Excel Data Import General";
        GL: Record "G/L Entry";
        VLE: Record "Vendor Ledger Entry";
        DVLE: Record "Detailed Vendor Ledg. Entry";
        PINVHDR: Record "Purch. Inv. Header";
        PINVLINE: Record "Purch. Inv. Line";
        VATE: Record "VAT Entry";
        ILE: Record "Item Ledger Entry";
        VALE: Record "Value Entry";
        FALE: Record "FA Ledger Entry";
        EntryNoInt: Integer;


}