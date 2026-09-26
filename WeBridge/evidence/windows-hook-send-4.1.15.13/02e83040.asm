
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e83040 <.text+0x2e82040>:
   182e83040:	56                   	push   rsi
   182e83041:	48 83 ec 20          	sub    rsp,0x20
   182e83045:	0f b6 51 34          	movzx  edx,BYTE PTR [rcx+0x34]
   182e83049:	85 d2                	test   edx,edx
   182e8304b:	0f 84 8c 00 00 00    	je     0x182e830dd
   182e83051:	f6 c2 01             	test   dl,0x1
   182e83054:	74 1a                	je     0x182e83070
   182e83056:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   182e8305a:	48 85 c0             	test   rax,rax
   182e8305d:	74 11                	je     0x182e83070
   182e8305f:	48 89 ce             	mov    rsi,rcx
   182e83062:	48 89 c1             	mov    rcx,rax
   182e83065:	e8 06 58 7f fd       	call   0x180678870
   182e8306a:	48 89 f1             	mov    rcx,rsi
   182e8306d:	8b 56 34             	mov    edx,DWORD PTR [rsi+0x34]
   182e83070:	f6 c2 02             	test   dl,0x2
   182e83073:	74 28                	je     0x182e8309d
   182e83075:	48 8b 41 10          	mov    rax,QWORD PTR [rcx+0x10]
   182e83079:	4c 8d 05 60 3d a9 08 	lea    r8,[rip+0x8a93d60]        # 0x18b916de0
   182e83080:	4c 39 c0             	cmp    rax,r8
   182e83083:	74 18                	je     0x182e8309d
   182e83085:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182e8308c:	00 
   182e8308d:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   182e83092:	72 03                	jb     0x182e83097
   182e83094:	48 8b 00             	mov    rax,QWORD PTR [rax]
   182e83097:	c6 00 00             	mov    BYTE PTR [rax],0x0
   182e8309a:	8b 51 34             	mov    edx,DWORD PTR [rcx+0x34]
   182e8309d:	48 c7 41 18 00 00 00 	mov    QWORD PTR [rcx+0x18],0x0
   182e830a4:	00 
   182e830a5:	c7 41 28 00 00 00 00 	mov    DWORD PTR [rcx+0x28],0x0
   182e830ac:	f6 c2 20             	test   dl,0x20
   182e830af:	74 25                	je     0x182e830d6
   182e830b1:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
   182e830b5:	48 8d 15 24 3d a9 08 	lea    rdx,[rip+0x8a93d24]        # 0x18b916de0
   182e830bc:	48 39 d0             	cmp    rax,rdx
   182e830bf:	74 15                	je     0x182e830d6
   182e830c1:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182e830c8:	00 
   182e830c9:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   182e830ce:	72 03                	jb     0x182e830d3
   182e830d0:	48 8b 00             	mov    rax,QWORD PTR [rax]
   182e830d3:	c6 00 00             	mov    BYTE PTR [rax],0x0
   182e830d6:	c7 41 2c 00 00 00 00 	mov    DWORD PTR [rcx+0x2c],0x0
   182e830dd:	c7 41 34 00 00 00 00 	mov    DWORD PTR [rcx+0x34],0x0
   182e830e4:	48 83 c4 20          	add    rsp,0x20
   182e830e8:	5e                   	pop    rsi
   182e830e9:	c3                   	ret
