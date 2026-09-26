
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182c6d230 <.text+0x2c6c230>:
   182c6d230:	56                   	push   rsi
   182c6d231:	57                   	push   rdi
   182c6d232:	48 83 ec 28          	sub    rsp,0x28
   182c6d236:	48 39 ca             	cmp    rdx,rcx
   182c6d239:	74 1d                	je     0x182c6d258
   182c6d23b:	48 89 d6             	mov    rsi,rdx
   182c6d23e:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   182c6d241:	48 89 cf             	mov    rdi,rcx
   182c6d244:	ff 50 18             	call   QWORD PTR [rax+0x18]
   182c6d247:	48 89 f9             	mov    rcx,rdi
   182c6d24a:	48 89 f2             	mov    rdx,rsi
   182c6d24d:	48 83 c4 28          	add    rsp,0x28
   182c6d251:	5f                   	pop    rdi
   182c6d252:	5e                   	pop    rsi
   182c6d253:	e9 48 fb ff ff       	jmp    0x182c6cda0
   182c6d258:	48 83 c4 28          	add    rsp,0x28
   182c6d25c:	5f                   	pop    rdi
   182c6d25d:	5e                   	pop    rsi
   182c6d25e:	c3                   	ret
