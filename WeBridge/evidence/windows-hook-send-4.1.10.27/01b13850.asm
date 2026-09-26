
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181b13850 <.text+0x1b12850>:
   181b13850:	56                   	push   rsi
   181b13851:	57                   	push   rdi
   181b13852:	48 83 ec 28          	sub    rsp,0x28
   181b13856:	48 89 d6             	mov    rsi,rdx
   181b13859:	48 89 cf             	mov    rdi,rcx
   181b1385c:	48 8d 51 08          	lea    rdx,[rcx+0x8]
   181b13860:	48 8d 05 31 26 a8 06 	lea    rax,[rip+0x6a82631]        # 0x188595e98
   181b13867:	48 89 06             	mov    QWORD PTR [rsi],rax
   181b1386a:	48 8d 4e 08          	lea    rcx,[rsi+0x8]
   181b1386e:	e8 dd 38 af fe       	call   0x180607150
   181b13873:	48 8b 47 10          	mov    rax,QWORD PTR [rdi+0x10]
   181b13877:	48 89 46 10          	mov    QWORD PTR [rsi+0x10],rax
   181b1387b:	48 89 f0             	mov    rax,rsi
   181b1387e:	48 83 c4 28          	add    rsp,0x28
   181b13882:	5f                   	pop    rdi
   181b13883:	5e                   	pop    rsi
   181b13884:	c3                   	ret
