{�ணࠬ�� �८�ࠧ������ ��䬥��᪮�� ��ࠦ����
� ������ ������� ������ (����䨪���).
���ࠡ��稪 - �㡨��� �. �.}
program CONVERTER;

{������祭�� ����� Crt}
uses crt;

{������� ����⠭�}
const
    INFIX_EXPR = '((a-(b+c))*d)^((e+f)^g)';

{��楤�� �뢮�� �� ��� �ਭ� ���� ��ਧ��⠫쭮� ������}
procedure hr;
    var
        i: integer;
    begin
        for i := 1 to 79 do write('-');
        writeln;
    end;

{�㭪��, ��������� �ਮ��� �����஢/���࠭���.
symbol - ��ࠬ���-����⠭� ⨯� char}
function getSymbolPriority(const symbol: char): shortint;
    begin
        case symbol of
            '(':                getSymbolPriority := 0;
            ')':                getSymbolPriority := 1;
            '+', '-':           getSymbolPriority := 2;
            '*', '/':           getSymbolPriority := 3;
            '^':                getSymbolPriority := 4;
            'a'..'z', 'A'..'Z': getSymbolPriority := 5;
        end;
    end;

{�㭪��, ��������� ������� �� ���設� �⥪�.
stack - ��ࠬ���-����⠭� ⨯� string}
function getTopStack(const stack: string): char;
    begin
        getTopStack := stack[length(stack)]
    end;

{��楤�� 㤠����� ������� �� ���設� �⥪�.
stack - ��ࠬ���-��६����� ⨯� string}
procedure popStack(var stack: string);
    begin
        delete(stack, length(stack), 1);
    end;

{��楤�� ��⠢�� ������� � ���設� �⥪�.
elem - ��ࠬ���-����⠭� ⨯� char,
stack - ��ࠬ���-��६����� ⨯� string}
procedure pushStack(const elem: char; var stack: string);
    begin
        stack := stack + elem;
    end;
{�㭪��, ��������� �ਧ��� ������ �⥪�.
stack - ��ࠬ���-����⠭� ⨯� string}
function isEmptyStack(const stack: string): boolean;
    begin
        if length(stack) > 0 then
            isEmptyStack := false
        else
            isEmptyStack := true;
    end;

{�㭪��, ��������� ��ࠦ���� � ���⭮� ����᪮� ����� (����䨪᭮�).
infix - ��ࠬ���-����⠭� ⨯� string}
function convertToPostfix(const infix: string): string;
    var
        symbol, topStack: char;
        postfix, stack: string;
        i, j, symbolPriority, topStackPriority: shortint;
        isLte: boolean;
    begin

        {���樠������ ��砫��� ���祭�� �������� ��६�����}
        symbolPriority := 0;
        topStackPriority := 0;
        postfix := '';
        stack := '';
        i := 1;

        {�࣠������ 横�� �� ������⠬ �室���� ��ࠦ����}
        while i <= length(infix) do
            begin

                {����祭�� ⥪�饣� ᨬ���� �室���� ��ࠦ����
                � ��� �ਮ���}
                symbol := infix[i];
                symbolPriority := getSymbolPriority(symbol);

                {������ �ਮ��� ⥪�饣� ᨬ����}
                if symbolPriority = 1 then

                    {����뢠��� ᪮��� ��⠫������ �� �⥪� ��������
                    �� ������襩 ���뢠�饩 ᪮��� �����⥫쭮.
                    ��⮫����� ��������, �� �᪫�祭��� ᪮���,
                    ��७������ � ��室��� ��ப�.}
                    begin
                        repeat
                            topStack := getTopStack(stack);
                            popStack(stack);
                            if topStack <> '(' then
                                postfix := postfix + topStack;
                        until topStack = '(';
                        topStackPriority := symbolPriority;
                    end
                else
                    begin
                        if (symbolPriority = 0) or
                           (symbolPriority > topStackPriority) then

                            {���������� ⥪�饣� ᨬ���� � ���設� �⥪�,
                            �᫨ ��� �ਮ��� ࠢ�� ��� (���뢠��� ᪮���)
                            ��� ����� �ਮ��� ᨬ����,
                            ��室�饣��� � ���設� �⥪�.}
                            begin
                                topStackPriority := symbolPriority;
                                pushStack(symbol, stack);
                            end
                        else

                            {��⠫������� �� �⥪� � ��७�� � ��室��� ��ப�
                            �������, ��室�饣��� � ���設� �⥪�, � ⠪��
                            ᫥���騥 �� ��� �������� � �ਮ��⠬�,
                            �� ����訬� �ਮ���� ⥪�饣� ᨬ����.}
                            begin
                                isLte := true;
                                repeat
                                    topStack := getTopStack(stack);
                                    topStackPriority := getSymbolPriority(topStack);
                                    if (symbolPriority > topStackPriority) or
                                       (topStack = '(') or
                                       (isEmptyStack(stack) = true) then
                                        begin
                                            pushStack(symbol, stack);
                                            topStackPriority := symbolPriority;
                                            isLte := false;
                                        end
                                    else
                                        begin
                                            popStack(stack);
                                            postfix := postfix + topStack;
                                        end;
                                until isLte = false;
                            end;
                    end;

                write(i:3, '|':1, symbol:5, '| ':5, stack, ' | ':(17-length(stack)), postfix);
                writeln;
                inc(i);
            end;

        {��⠫������� ��� ��⠢���� � �⥪� ᨬ�����
        � ��७�� �� � ��室��� ��ப�.}
        if isEmptyStack(stack) = false then
            for j := length(stack) downto 1 do
                begin
                    postfix := postfix + getTopStack(stack);
                    popStack(stack);
                end;
        writeln(i:3, '|':1, '|':9, '| ':18, postfix);

        convertToPostfix := postfix;
    end;

{��楤�� �ᯮ������ �ணࠬ��}
procedure runApplication;
    var
        infixExpr, postfixExpr: string;
    begin
        clrscr; {���⪠ ��⨢���� ����}
        infixExpr := INFIX_EXPR; {���樠������ �室���� ��䬥��᪮�� ��ࠦ����}
        writeln('�室��� ��ࠦ����: ', infixExpr);
        hr;
        writeln(' � | ':5, '������ | ':9, '�⥪', '| ':13, '����䨪᭠� ��ப�');
        hr;
        postfixExpr := convertToPostfix(infixExpr); {�८�ࠧ������}
        hr;
        writeln('���⭠� ����᪠� ������ (����䨪᭠�): ', postfixExpr);
        readkey; {�������� ������ ������}
    end;

begin
    runApplication;
end.