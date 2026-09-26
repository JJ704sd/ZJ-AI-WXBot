
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e83dd0 <.text+0x2e82dd0>:
   182e83dd0:	56                   	push   rsi
   182e83dd1:	57                   	push   rdi
   182e83dd2:	48 83 ec 28          	sub    rsp,0x28
   182e83dd6:	48 39 ca             	cmp    rdx,rcx
   182e83dd9:	74 1d                	je     0x182e83df8
   182e83ddb:	48 89 d6             	mov    rsi,rdx
   182e83dde:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   182e83de1:	48 89 cf             	mov    rdi,rcx
   182e83de4:	ff 50 18             	call   QWORD PTR [rax+0x18]
   182e83de7:	48 89 f9             	mov    rcx,rdi
   182e83dea:	48 89 f2             	mov    rdx,rsi
   182e83ded:	48 83 c4 28          	add    rsp,0x28
   182e83df1:	5f                   	pop    rdi
   182e83df2:	5e                   	pop    rsi
   182e83df3:	e9 48 fb ff ff       	jmp    0x182e83940
   182e83df8:	48 83 c4 28          	add    rsp,0x28
   182e83dfc:	5f                   	pop    rdi
   182e83dfd:	5e                   	pop    rsi
   182e83dfe:	c3                   	ret
