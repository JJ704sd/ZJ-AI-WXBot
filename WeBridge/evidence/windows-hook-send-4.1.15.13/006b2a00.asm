
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001806b2a00 <.text+0x6b1a00>:
   1806b2a00:	56                   	push   rsi
   1806b2a01:	57                   	push   rdi
   1806b2a02:	53                   	push   rbx
   1806b2a03:	48 83 ec 20          	sub    rsp,0x20
   1806b2a07:	48 89 ce             	mov    rsi,rcx
   1806b2a0a:	48 8d 05 f7 f2 78 08 	lea    rax,[rip+0x878f2f7]        # 0x188e41d08
   1806b2a11:	48 89 01             	mov    QWORD PTR [rcx],rax
   1806b2a14:	48 8b 89 50 02 00 00 	mov    rcx,QWORD PTR [rcx+0x250]
   1806b2a1b:	48 85 c9             	test   rcx,rcx
   1806b2a1e:	74 34                	je     0x1806b2a54
   1806b2a20:	48 8b 96 60 02 00 00 	mov    rdx,QWORD PTR [rsi+0x260]
   1806b2a27:	48 29 ca             	sub    rdx,rcx
   1806b2a2a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806b2a31:	72 1c                	jb     0x1806b2a4f
   1806b2a33:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   1806b2a37:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806b2a3b:	48 29 c1             	sub    rcx,rax
   1806b2a3e:	48 83 f9 20          	cmp    rcx,0x20
   1806b2a42:	0f 83 21 02 00 00    	jae    0x1806b2c69
   1806b2a48:	48 83 c2 27          	add    rdx,0x27
   1806b2a4c:	48 89 c1             	mov    rcx,rax
   1806b2a4f:	e8 8c 8e df 06       	call   0x1874ab8e0
   1806b2a54:	48 8d 8e 40 02 00 00 	lea    rcx,[rsi+0x240]
   1806b2a5b:	48 8b 96 40 02 00 00 	mov    rdx,QWORD PTR [rsi+0x240]
   1806b2a62:	e8 49 91 9a ff       	call   0x18005bbb0
   1806b2a67:	48 8b 8e 40 02 00 00 	mov    rcx,QWORD PTR [rsi+0x240]
   1806b2a6e:	ba 40 00 00 00       	mov    edx,0x40
   1806b2a73:	e8 68 8e df 06       	call   0x1874ab8e0
   1806b2a78:	48 8b be 30 02 00 00 	mov    rdi,QWORD PTR [rsi+0x230]
   1806b2a7f:	48 85 ff             	test   rdi,rdi
   1806b2a82:	74 1d                	je     0x1806b2aa1
   1806b2a84:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1806b2a88:	75 17                	jne    0x1806b2aa1
   1806b2a8a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1806b2a8d:	48 89 f9             	mov    rcx,rdi
   1806b2a90:	ff 10                	call   QWORD PTR [rax]
   1806b2a92:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1806b2a96:	75 09                	jne    0x1806b2aa1
   1806b2a98:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1806b2a9b:	48 89 f9             	mov    rcx,rdi
   1806b2a9e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806b2aa1:	48 8b 8e 00 02 00 00 	mov    rcx,QWORD PTR [rsi+0x200]
   1806b2aa8:	48 85 c9             	test   rcx,rcx
   1806b2aab:	74 34                	je     0x1806b2ae1
   1806b2aad:	48 8b 96 10 02 00 00 	mov    rdx,QWORD PTR [rsi+0x210]
   1806b2ab4:	48 29 ca             	sub    rdx,rcx
   1806b2ab7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806b2abe:	72 1c                	jb     0x1806b2adc
   1806b2ac0:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   1806b2ac4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806b2ac8:	48 29 c1             	sub    rcx,rax
   1806b2acb:	48 83 f9 20          	cmp    rcx,0x20
   1806b2acf:	0f 83 94 01 00 00    	jae    0x1806b2c69
   1806b2ad5:	48 83 c2 27          	add    rdx,0x27
   1806b2ad9:	48 89 c1             	mov    rcx,rax
   1806b2adc:	e8 ff 8d df 06       	call   0x1874ab8e0
   1806b2ae1:	48 8b 86 f0 01 00 00 	mov    rax,QWORD PTR [rsi+0x1f0]
   1806b2ae8:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   1806b2aec:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
   1806b2af3:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   1806b2af6:	48 85 d2             	test   rdx,rdx
   1806b2af9:	74 28                	je     0x1806b2b23
   1806b2afb:	48 8d be f0 01 00 00 	lea    rdi,[rsi+0x1f0]
   1806b2b02:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1806b2b09:	1f 84 00 00 00 00 00 
   1806b2b10:	48 8b 1a             	mov    rbx,QWORD PTR [rdx]
   1806b2b13:	48 89 f9             	mov    rcx,rdi
   1806b2b16:	e8 05 0a a0 ff       	call   0x1800b3520
   1806b2b1b:	48 89 da             	mov    rdx,rbx
   1806b2b1e:	48 85 db             	test   rbx,rbx
   1806b2b21:	75 ed                	jne    0x1806b2b10
   1806b2b23:	48 8b 8e f0 01 00 00 	mov    rcx,QWORD PTR [rsi+0x1f0]
   1806b2b2a:	ba 50 00 00 00       	mov    edx,0x50
   1806b2b2f:	e8 ac 8d df 06       	call   0x1874ab8e0
   1806b2b34:	48 8b 8e c0 01 00 00 	mov    rcx,QWORD PTR [rsi+0x1c0]
   1806b2b3b:	48 85 c9             	test   rcx,rcx
   1806b2b3e:	74 34                	je     0x1806b2b74
   1806b2b40:	48 8b 96 d0 01 00 00 	mov    rdx,QWORD PTR [rsi+0x1d0]
   1806b2b47:	48 29 ca             	sub    rdx,rcx
   1806b2b4a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806b2b51:	72 1c                	jb     0x1806b2b6f
   1806b2b53:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   1806b2b57:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806b2b5b:	48 29 c1             	sub    rcx,rax
   1806b2b5e:	48 83 f9 20          	cmp    rcx,0x20
   1806b2b62:	0f 83 01 01 00 00    	jae    0x1806b2c69
   1806b2b68:	48 83 c2 27          	add    rdx,0x27
   1806b2b6c:	48 89 c1             	mov    rcx,rax
   1806b2b6f:	e8 6c 8d df 06       	call   0x1874ab8e0
   1806b2b74:	48 8d 8e b0 01 00 00 	lea    rcx,[rsi+0x1b0]
   1806b2b7b:	e8 a0 fd ff ff       	call   0x1806b2920
   1806b2b80:	48 8b 8e 80 01 00 00 	mov    rcx,QWORD PTR [rsi+0x180]
   1806b2b87:	48 85 c9             	test   rcx,rcx
   1806b2b8a:	74 34                	je     0x1806b2bc0
   1806b2b8c:	48 8b 96 90 01 00 00 	mov    rdx,QWORD PTR [rsi+0x190]
   1806b2b93:	48 29 ca             	sub    rdx,rcx
   1806b2b96:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806b2b9d:	72 1c                	jb     0x1806b2bbb
   1806b2b9f:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   1806b2ba3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806b2ba7:	48 29 c1             	sub    rcx,rax
   1806b2baa:	48 83 f9 20          	cmp    rcx,0x20
   1806b2bae:	0f 83 b5 00 00 00    	jae    0x1806b2c69
   1806b2bb4:	48 83 c2 27          	add    rdx,0x27
   1806b2bb8:	48 89 c1             	mov    rcx,rax
   1806b2bbb:	e8 20 8d df 06       	call   0x1874ab8e0
   1806b2bc0:	48 8d 8e 70 01 00 00 	lea    rcx,[rsi+0x170]
   1806b2bc7:	e8 44 fb ff ff       	call   0x1806b2710
   1806b2bcc:	48 8b 8e 40 01 00 00 	mov    rcx,QWORD PTR [rsi+0x140]
   1806b2bd3:	48 85 c9             	test   rcx,rcx
   1806b2bd6:	74 30                	je     0x1806b2c08
   1806b2bd8:	48 8b 96 50 01 00 00 	mov    rdx,QWORD PTR [rsi+0x150]
   1806b2bdf:	48 29 ca             	sub    rdx,rcx
   1806b2be2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806b2be9:	72 18                	jb     0x1806b2c03
   1806b2beb:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   1806b2bef:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806b2bf3:	48 29 c1             	sub    rcx,rax
   1806b2bf6:	48 83 f9 20          	cmp    rcx,0x20
   1806b2bfa:	73 6d                	jae    0x1806b2c69
   1806b2bfc:	48 83 c2 27          	add    rdx,0x27
   1806b2c00:	48 89 c1             	mov    rcx,rax
   1806b2c03:	e8 d8 8c df 06       	call   0x1874ab8e0
   1806b2c08:	48 8d 8e 30 01 00 00 	lea    rcx,[rsi+0x130]
   1806b2c0f:	e8 fc fa ff ff       	call   0x1806b2710
   1806b2c14:	48 8d be a8 00 00 00 	lea    rdi,[rsi+0xa8]
   1806b2c1b:	48 8d 8e b8 00 00 00 	lea    rcx,[rsi+0xb8]
   1806b2c22:	e8 39 12 de ff       	call   0x180493e60
   1806b2c27:	48 89 f9             	mov    rcx,rdi
   1806b2c2a:	e8 51 16 de ff       	call   0x180494280
   1806b2c2f:	48 8d 7e 28          	lea    rdi,[rsi+0x28]
   1806b2c33:	48 8d 4e 38          	lea    rcx,[rsi+0x38]
   1806b2c37:	e8 24 12 de ff       	call   0x180493e60
   1806b2c3c:	48 89 f9             	mov    rcx,rdi
   1806b2c3f:	e8 3c 16 de ff       	call   0x180494280
   1806b2c44:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   1806b2c48:	48 85 c9             	test   rcx,rcx
   1806b2c4b:	74 14                	je     0x1806b2c61
   1806b2c4d:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   1806b2c51:	75 0e                	jne    0x1806b2c61
   1806b2c53:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1806b2c56:	48 83 c4 20          	add    rsp,0x20
   1806b2c5a:	5b                   	pop    rbx
   1806b2c5b:	5f                   	pop    rdi
   1806b2c5c:	5e                   	pop    rsi
   1806b2c5d:	48 ff 60 08          	rex.W jmp QWORD PTR [rax+0x8]
   1806b2c61:	48 83 c4 20          	add    rsp,0x20
   1806b2c65:	5b                   	pop    rbx
   1806b2c66:	5f                   	pop    rdi
   1806b2c67:	5e                   	pop    rsi
   1806b2c68:	c3                   	ret
   1806b2c69:	e8 1e a7 e5 06       	call   0x18750d38c
   1806b2c6e:	cc                   	int3
