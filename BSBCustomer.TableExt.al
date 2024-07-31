tableextension 50100 "BSB Customer" extends Customer
{
    fields
    {
        field(50100; "BSB Favorite Book Nr."; Code[20])
        {
            Caption = 'Favorite Book Nr.';
            TableRelation = "BSB Book";

            trigger OnValidate()
            var
                BSBBook: Record "BSB Book";
            begin

                if ("BSB Favorite Book Nr." <> '') and ("BSB Favorite Book Nr." <> xRec."BSB Favorite Book Nr.") then begin
                    // BSBBook.Get("BSB Favorite Book Nr.");
                    // BSBBook.TestBlocked();
                    BSBBook.TestBlocked("BSB Favorite Book Nr.");
                    BSBBook.TestBlocked();
                end;

                if ("BSB Favorite Book Nr." <> xRec."BSB Favorite Book Nr.") and (CurrFieldNo > 0) then
                    CalcFields("BSB Favorite Book Description");
            end;
        }
        field(50101; "BSB Favorite Book Description"; Text[100])
        {
            Caption = 'Favorite Book Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("BSB Book".Description where("No." = field("BSB Favorite Book Nr.")));
        }
    }
}