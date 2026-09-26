
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181b13600 <.text+0x1b12600>:
   181b13600:	56                   	push   rsi
   181b13601:	57                   	push   rdi
   181b13602:	48 83 ec 28          	sub    rsp,0x28
   181b13606:	48 89 d6             	mov    rsi,rdx
   181b13609:	48 89 cf             	mov    rdi,rcx
   181b1360c:	48 8d 51 08          	lea    rdx,[rcx+0x8]
   181b13610:	48 8d 05 c1 27 a8 06 	lea    rax,[rip+0x6a827c1]        # 0x188595dd8
   181b13617:	48 89 06             	mov    QWORD PTR [rsi],rax
   181b1361a:	48 8d 4e 08          	lea    rcx,[rsi+0x8]
   181b1361e:	e8 2d 3b af fe       	call   0x180607150
   181b13623:	48 8b 47 10          	mov    rax,QWORD PTR [rdi+0x10]
   181b13627:	48 89 46 10          	mov    QWORD PTR [rsi+0x10],rax
   181b1362b:	48 89 f0             	mov    rax,rsi
   181b1362e:	48 83 c4 28          	add    rsp,0x28
   181b13632:	5f                   	pop    rdi
   181b13633:	5e                   	pop    rsi
   181b13634:	c3                   	ret
