#pragma warning disable AA0215
page 50112 "Update PSI Fields"
#pragma warning restore AA0215


{
    PageType = Card;
    Caption = 'Update PSI Related Data All files';
    ApplicationArea = All;
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RMID,
                    tabledata "Sales Invoice Header" = RIMD,
                    tabledata "Sales Invoice Line" = RIMD,
                    tabledata "Cust. Ledger Entry" = RIMD,
                    tabledata "Detailed Cust. Ledg. Entry" = RIMD,
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

                        // Update Customer Ledger Entry-------------------------------------------------

                        this.CLE.Reset();
                        this.CLE.SetFilter(this.CLE."Document No.", '%1', this.ExcelData."Document No.");

                        if this.CLE.FindFirst() then
                            repeat


                                if this.ExcelData.UpdateField = 'Amount' then begin

                                    this.CLE."Original Amt. (LCY)" := this.ExcelData."Value 2";
                                    this.CLE."Amount (LCY)" := this.ExcelData."Value 2";
                                    this.CLE."Sales (LCY)" := this.ExcelData."Value 2";
                                    this.CLE."Debit Amount (LCY)" := 0;
                                    this.CLE."Credit Amount (LCY)" := 0;

                                    if this.ExcelData."Value 2" > 0 then
                                        this.CLE."Debit Amount (LCY)" := this.ExcelData."Value 2"
                                    else
                                        this.CLE."Credit Amount (LCY)" := this.ExcelData."Value 2";

                                end;

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.CLE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.CLE."Document No.", this.ExcelData."Value 4");


                                this.CLE.Modify();

                            until this.CLE.Next() = 0;

                        this.DCLE.Reset();
                        this.DCLE.SetFilter(this.DCLE."Document No.", '%1', this.ExcelData."Document No.");
                        if this.DCLE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.DCLE."Posting Date", this.ExcelData."Value 3");

                                if this.ExcelData.UpdateField = 'DocumentNo' then
                                    evaluate(this.DCLE."Document No.", this.ExcelData."Value 4");


                                this.DCLE.Modify();
                            until this.DCLE.Next() = 0;



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


                        this.SINVLINE.Reset();
                        this.SINVLINE.SetFilter(this.SINVLINE."Document No.", '%1', this.ExcelData."Document No.");

                        if this.SINVLINE.FindFirst() then
                            repeat

                                if this.ExcelData.UpdateField = 'PostDate' then
                                    evaluate(this.SINVLINE."Posting Date", this.ExcelData."Value 3");

                                this.TempSINVLINE.Reset();
                                if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                    // Create temporary copy of the record
                                    this.TempSINVLINE := this.SINVLINE;
                                    this.SINVLINE.Delete();
                                    this.SINVLINE := this.TempSINVLINE;
                                    this.SINVLINE."Document No." := this.ExcelData."Value 4";
                                    this.SINVLINE.Insert();
                                end;

                            until this.SINVLINE.Next() = 0;


                        this.SINVHDR.Reset();
                        this.SINVHDR.SetFilter(this.SINVHDR."No.", '%1', this.ExcelData."Document No.");

                        if this.SINVHDR.FindFirst() then begin


                            if this.ExcelData.UpdateField = 'PostDate' then
                                evaluate(this.SINVHDR."Posting Date", this.ExcelData."Value 3");


                            if this.ExcelData.UpdateField = 'DocumentNo' then begin
                                // Create temporary copy of the record
                                this.TempSINVHDR := this.SINVHDR;

                                // Delete old record
                                this.SINVHDR.Delete();

                                // Create new record with new doc number
                                this.SINVHDR := this.TempSINVHDR;
                                this.SINVHDR."No." := this.ExcelData."Value 4";
                                this.SINVHDR.Insert();

                            end;

                        end;



                    until this.ExcelData.Next() = 0;


                    Message('Process Finished');
                end;



            }

        }
    }

    var

        TempSINVHDR: Record "Sales Invoice Header" temporary;
        TempSINVLINE: Record "Sales Invoice Line" temporary;
        ExcelData: Record "Excel Data Import General";
        GL: Record "G/L Entry";
        CLE: Record "Cust. Ledger Entry";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        SINVHDR: Record "Sales Invoice Header";

        SINVLINE: Record "Sales Invoice Line";
        VATE: Record "VAT Entry";
        ILE: Record "Item Ledger Entry";
        VALE: Record "Value Entry";
        EntryNoInt: Integer;


}