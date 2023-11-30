// Program to generate defines from Input and Output in scicos diagram.
//  
//
function [err]=Agrega_defines()

ES_ini=["SW1","SW2","LED1","LED2","EPWM1A","EPWM2A","EQEP1","EQEP2","ECAP1","ADCINA1","ADCINA2",...
"DACOUTA","DATSER1","DATSER2","DATSER34","DATSERIN","EQEP2_DIS"];

aa=size(ES_ini);
num_ES=aa(2);

// get file separator
fs = filesep();
filena2=pwd()+fs+getCurrentSystem()+".xml"
disp(filena2)
// Check if the file exist in folder 
[fd,existe_arch]=mopen(filena2);
if existe_arch==0,
 doc =xmlRead(filena2);
 // Open include file in order to save new defines
 //
 Dir_pro=fileparts(pwd(),"path");  // return a subpath 
 disp(Dir_pro)
 
 [fd,err]=mopen(Dir_pro+"/inc/hardware3.h", "r+")
 disp(fd)
 disp(err)
 if err~=0, disp("Please setup the project path in the scilab command (even include the X2CCode subpath)  "); return; end
 // Read include file 
 i=1
 while 1
     A(i)=mgetl(fd, 1)
     if meof(fd) then break;
     end
     i=i+1;
 end    
 mclose(fd)

  [fd,err]=mopen(Dir_pro+"/inc/hardware3.h", "w+")

  for j=1:106,
   mputl(A(j),fd);
  end

 //disp(A)
 // Incluye cabecera
 mputl("// Define of Input and Output List",fd);
 mputl("// Scicos block run Result",fd);

 num_e=doc.root.children(3).children(2).children.size;
 num_s=doc.root.children(4).children(2).children.size;

 for j=1:num_ES,
     flag=0;
     for i=1:num_e,
         nombreE(i)=doc.root.children(3).children(2).children(i).children(3).attributes.Name;
         if ~strcmp(nombreE(i),ES_ini(j)), flag=1; break; end

     end //i
     if flag==0,
         for i=1:num_s,
             nombreS(i)=doc.root.children(4).children(2).children(i).children(3).attributes.Name;
             if ~strcmp(nombreS(i),ES_ini(j)), flag=1; break; end
         end //i
     end

     if flag,
         disp("#define "+ES_ini(j)+" 1");
         mputl("#define "+ES_ini(j)+" 1",fd);
     else 
         disp("#define "+ES_ini(j)+" 0");
         mputl("#define "+ES_ini(j)+" 0",fd);
     end
 end
else   
    disp("****Please setup the project path in the scilab command (even include the X2CCode subpath)");
    return;
end

mclose(fd)
endfunction

