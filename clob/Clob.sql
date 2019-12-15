
Drop table bfiles;
drop table clobs;
create table bfiles(
id number (5),
text bfile);

drop directory bfile_dir;

CREATE OR REPLACE DIRECTORY bfile_dir
AS 'D:\Users\Camelia\Desktop\bd-ludotheque\clob';


delete from bfiles;
INSERT INTO bfiles
VALUES(1, BFILENAME('BFILE_DIR', 'fichierClob.txt'));
create table clobs(
id number (5),
text clob);
declare
cursor c is
select id, text from bfiles;
v_clob clob;
lg number(38);
begin
for j in c
loop
	Dbms_Lob.FileOpen ( j.text, Dbms_Lob.File_Readonly );
	lg:=Dbms_Lob.GETLENGTH(j.text);
	insert into clobs ( id, text )
	values ( j.id, empty_clob() )
	returning text into v_clob;
	Dbms_Lob.LoadFromFile(
	dest_lob => v_clob,
	src_lob => j.text,
	amount => lg,
	dest_offset => 1,
	src_offset => 1);
	--amount => 4294967296, /* = 4Gb */
	Dbms_Lob.FileClose ( j.text );
end loop;
commit;
end;

/* POUR LE SELECT */
BEGIN
	SELECT cv_anime INTO lobCvAnime
	FROM lpilote WHERE pl#=1;
	LOOP
		DBMS_LOB.READ(lobCvAnime, qte, position,
		buffer);
		/* Insérer les Manipulations ICI*/
		position := position+qte;
	END LOOP;
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('No More Data');
END;
/
