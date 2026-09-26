
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000183d09d00 <.text+0x3d08d00>:
   183d09d00:	55                   	push   rbp
   183d09d01:	41 56                	push   r14
   183d09d03:	56                   	push   rsi
   183d09d04:	57                   	push   rdi
   183d09d05:	53                   	push   rbx
   183d09d06:	48 81 ec 30 03 00 00 	sub    rsp,0x330
   183d09d0d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   183d09d14:	00 
   183d09d15:	0f 29 b5 a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm6
   183d09d1c:	48 c7 85 98 02 00 00 	mov    QWORD PTR [rbp+0x298],0xfffffffffffffffe
   183d09d23:	fe ff ff ff 
   183d09d27:	44 88 cb             	mov    bl,r9b
   183d09d2a:	4c 89 85 78 02 00 00 	mov    QWORD PTR [rbp+0x278],r8
   183d09d31:	48 89 95 90 02 00 00 	mov    QWORD PTR [rbp+0x290],rdx
   183d09d38:	48 89 ce             	mov    rsi,rcx
   183d09d3b:	0f 28 35 6e be 03 05 	movaps xmm6,XMMWORD PTR [rip+0x503be6e]        # 0x188d45bb0
   183d09d42:	0f 29 b5 80 02 00 00 	movaps XMMWORD PTR [rbp+0x280],xmm6
   183d09d49:	48 8d 8d 80 02 00 00 	lea    rcx,[rbp+0x280]
   183d09d50:	e8 1b af 9e fc       	call   0x1806f4c70
   183d09d55:	90                   	nop
   183d09d56:	48 8d bd c8 00 00 00 	lea    rdi,[rbp+0xc8]
   183d09d5d:	48 8b 8d 78 02 00 00 	mov    rcx,QWORD PTR [rbp+0x278]
   183d09d64:	48 89 fa             	mov    rdx,rdi
   183d09d67:	e8 34 ba 37 fc       	call   0x1800857a0
   183d09d6c:	90                   	nop
   183d09d6d:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   183d09d74:	4c 8d b0 58 07 00 00 	lea    r14,[rax+0x758]
   183d09d7b:	49 39 fe             	cmp    r14,rdi
   183d09d7e:	74 5a                	je     0x183d09dda
   183d09d80:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   183d09d87:	48 83 f8 10          	cmp    rax,0x10
   183d09d8b:	72 34                	jb     0x183d09dc1
   183d09d8d:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   183d09d90:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183d09d94:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183d09d9b:	72 1f                	jb     0x183d09dbc
   183d09d9d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183d09da1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183d09da5:	4c 29 c1             	sub    rcx,r8
   183d09da8:	48 83 f9 20          	cmp    rcx,0x20
   183d09dac:	0f 83 83 04 00 00    	jae    0x183d0a235
   183d09db2:	48 83 c0 28          	add    rax,0x28
   183d09db6:	48 89 c2             	mov    rdx,rax
   183d09db9:	4c 89 c1             	mov    rcx,r8
   183d09dbc:	e8 1f 1b 7a 03       	call   0x1874ab8e0
   183d09dc1:	0f 10 85 c8 00 00 00 	movups xmm0,XMMWORD PTR [rbp+0xc8]
   183d09dc8:	0f 10 8d d8 00 00 00 	movups xmm1,XMMWORD PTR [rbp+0xd8]
   183d09dcf:	41 0f 11 4e 10       	movups XMMWORD PTR [r14+0x10],xmm1
   183d09dd4:	41 0f 11 06          	movups XMMWORD PTR [r14],xmm0
   183d09dd8:	eb 45                	jmp    0x183d09e1f
   183d09dda:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   183d09de1:	48 83 f8 10          	cmp    rax,0x10
   183d09de5:	72 38                	jb     0x183d09e1f
   183d09de7:	48 8b 8d c8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc8]
   183d09dee:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183d09df2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183d09df9:	72 1f                	jb     0x183d09e1a
   183d09dfb:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183d09dff:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183d09e03:	4c 29 c1             	sub    rcx,r8
   183d09e06:	48 83 f9 20          	cmp    rcx,0x20
   183d09e0a:	0f 83 25 04 00 00    	jae    0x183d0a235
   183d09e10:	48 83 c0 28          	add    rax,0x28
   183d09e14:	48 89 c2             	mov    rdx,rax
   183d09e17:	4c 89 c1             	mov    rcx,r8
   183d09e1a:	e8 c1 1a 7a 03       	call   0x1874ab8e0
   183d09e1f:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   183d09e26:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   183d09e2d:	00 00 00 
   183d09e30:	48 8d 8d c8 00 00 00 	lea    rcx,[rbp+0xc8]
   183d09e37:	48 8b 95 78 02 00 00 	mov    rdx,QWORD PTR [rbp+0x278]
   183d09e3e:	e8 6d db 31 fc       	call   0x1800279b0
   183d09e43:	90                   	nop
   183d09e44:	48 8b 8d c8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc8]
   183d09e4b:	48 63 41 04          	movsxd rax,DWORD PTR [rcx+0x4]
   183d09e4f:	48 8b 95 80 02 00 00 	mov    rdx,QWORD PTR [rbp+0x280]
   183d09e56:	48 89 82 c8 01 00 00 	mov    QWORD PTR [rdx+0x1c8],rax
   183d09e5d:	8b 01                	mov    eax,DWORD PTR [rcx]
   183d09e5f:	83 f8 ff             	cmp    eax,0xffffffff
   183d09e62:	74 20                	je     0x183d09e84
   183d09e64:	85 c0                	test   eax,eax
   183d09e66:	74 0c                	je     0x183d09e74
   183d09e68:	f0 ff 09             	lock dec DWORD PTR [rcx]
   183d09e6b:	75 17                	jne    0x183d09e84
   183d09e6d:	48 8b 8d c8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc8]
   183d09e74:	ba 01 00 00 00       	mov    edx,0x1
   183d09e79:	41 b8 08 00 00 00    	mov    r8d,0x8
   183d09e7f:	e8 ac ea 32 fc       	call   0x180038930
   183d09e84:	0f 29 b5 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm6
   183d09e8b:	0f 29 b5 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm6
   183d09e92:	0f 29 b5 40 02 00 00 	movaps XMMWORD PTR [rbp+0x240],xmm6
   183d09e99:	48 8b be 00 07 00 00 	mov    rdi,QWORD PTR [rsi+0x700]
   183d09ea0:	48 81 c6 f8 06 00 00 	add    rsi,0x6f8
   183d09ea7:	48 8d 95 c8 00 00 00 	lea    rdx,[rbp+0xc8]
   183d09eae:	48 89 f1             	mov    rcx,rsi
   183d09eb1:	e8 4a 34 9a fc       	call   0x1806ad300
   183d09eb6:	90                   	nop
   183d09eb7:	48 8d 8d 40 02 00 00 	lea    rcx,[rbp+0x240]
   183d09ebe:	48 8d 95 c8 00 00 00 	lea    rdx,[rbp+0xc8]
   183d09ec5:	49 89 f8             	mov    r8,rdi
   183d09ec8:	e8 03 35 9a fc       	call   0x1806ad3d0
   183d09ecd:	90                   	nop
   183d09ece:	48 8d b5 50 02 00 00 	lea    rsi,[rbp+0x250]
   183d09ed5:	48 8d 8d c8 00 00 00 	lea    rcx,[rbp+0xc8]
   183d09edc:	e8 af 33 9a fc       	call   0x1806ad290
   183d09ee1:	0f 57 c0             	xorps  xmm0,xmm0
   183d09ee4:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   183d09ee7:	48 8b 85 88 02 00 00 	mov    rax,QWORD PTR [rbp+0x288]
   183d09eee:	48 85 c0             	test   rax,rax
   183d09ef1:	74 0d                	je     0x183d09f00
   183d09ef3:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183d09ef7:	48 8b b5 88 02 00 00 	mov    rsi,QWORD PTR [rbp+0x288]
   183d09efe:	eb 02                	jmp    0x183d09f02
   183d09f00:	31 f6                	xor    esi,esi
   183d09f02:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   183d09f09:	48 89 85 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rax
   183d09f10:	48 89 b5 58 02 00 00 	mov    QWORD PTR [rbp+0x258],rsi
   183d09f17:	48 8b 85 90 02 00 00 	mov    rax,QWORD PTR [rbp+0x290]
   183d09f1e:	0f 10 00             	movups xmm0,XMMWORD PTR [rax]
   183d09f21:	48 8b 00             	mov    rax,QWORD PTR [rax]
   183d09f24:	0f 29 85 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm0
   183d09f2b:	48 85 c0             	test   rax,rax
   183d09f2e:	74 0a                	je     0x183d09f3a
   183d09f30:	f0 ff 00             	lock inc DWORD PTR [rax]
   183d09f33:	48 8b b5 88 02 00 00 	mov    rsi,QWORD PTR [rbp+0x288]
   183d09f3a:	48 8d 15 d7 04 52 05 	lea    rdx,[rip+0x55204d7]        # 0x18922a418
   183d09f41:	48 8d 8d c8 00 00 00 	lea    rcx,[rbp+0xc8]
   183d09f48:	41 b8 28 01 00 00    	mov    r8d,0x128
   183d09f4e:	e8 fd a0 83 03       	call   0x187544050
   183d09f53:	0f 57 c0             	xorps  xmm0,xmm0
   183d09f56:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   183d09f5d:	48 85 f6             	test   rsi,rsi
   183d09f60:	74 0d                	je     0x183d09f6f
   183d09f62:	f0 ff 46 08          	lock inc DWORD PTR [rsi+0x8]
   183d09f66:	48 8b 85 88 02 00 00 	mov    rax,QWORD PTR [rbp+0x288]
   183d09f6d:	eb 02                	jmp    0x183d09f71
   183d09f6f:	31 c0                	xor    eax,eax
   183d09f71:	48 8b 8d 80 02 00 00 	mov    rcx,QWORD PTR [rbp+0x280]
   183d09f78:	48 89 8d 30 02 00 00 	mov    QWORD PTR [rbp+0x230],rcx
   183d09f7f:	48 89 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],rax
   183d09f86:	48 8d 4d a0          	lea    rcx,[rbp-0x60]
   183d09f8a:	48 8d 95 30 02 00 00 	lea    rdx,[rbp+0x230]
   183d09f91:	e8 ba b7 44 fe       	call   0x182155750
   183d09f96:	90                   	nop
   183d09f97:	48 8d 4d a0          	lea    rcx,[rbp-0x60]
   183d09f9b:	89 da                	mov    edx,ebx
   183d09f9d:	e8 ae 4b 47 fe       	call   0x18217eb50
   183d09fa2:	90                   	nop
   183d09fa3:	48 8b 8d 90 02 00 00 	mov    rcx,QWORD PTR [rbp+0x290]
   183d09faa:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   183d09fad:	48 85 c9             	test   rcx,rcx
   183d09fb0:	74 14                	je     0x183d09fc6
   183d09fb2:	8b 49 04             	mov    ecx,DWORD PTR [rcx+0x4]
   183d09fb5:	85 c9                	test   ecx,ecx
   183d09fb7:	74 0d                	je     0x183d09fc6
   183d09fb9:	48 8b 8d 90 02 00 00 	mov    rcx,QWORD PTR [rbp+0x290]
   183d09fc0:	48 8b 51 08          	mov    rdx,QWORD PTR [rcx+0x8]
   183d09fc4:	eb 02                	jmp    0x183d09fc8
   183d09fc6:	31 d2                	xor    edx,edx
   183d09fc8:	48 89 c1             	mov    rcx,rax
   183d09fcb:	e8 a0 4b 47 fe       	call   0x18217eb70
   183d09fd0:	90                   	nop
   183d09fd1:	48 89 c6             	mov    rsi,rax
   183d09fd4:	48 c7 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],0x0
   183d09fdb:	00 00 00 00 
   183d09fdf:	48 8d 05 92 5a 86 05 	lea    rax,[rip+0x5865a92]        # 0x18956fa78
   183d09fe6:	48 89 85 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],rax
   183d09fed:	48 8d 8d f8 01 00 00 	lea    rcx,[rbp+0x1f8]
   183d09ff4:	48 8d 95 40 02 00 00 	lea    rdx,[rbp+0x240]
   183d09ffb:	e8 c0 32 9a fc       	call   0x1806ad2c0
   183d0a000:	90                   	nop
   183d0a001:	48 8b 8d 48 02 00 00 	mov    rcx,QWORD PTR [rbp+0x248]
   183d0a008:	48 8b 85 58 02 00 00 	mov    rax,QWORD PTR [rbp+0x258]
   183d0a00f:	48 89 8d 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rcx
   183d0a016:	0f 57 c0             	xorps  xmm0,xmm0
   183d0a019:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   183d0a020:	48 85 c0             	test   rax,rax
   183d0a023:	74 0d                	je     0x183d0a032
   183d0a025:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183d0a029:	48 8b 85 58 02 00 00 	mov    rax,QWORD PTR [rbp+0x258]
   183d0a030:	eb 02                	jmp    0x183d0a034
   183d0a032:	31 c0                	xor    eax,eax
   183d0a034:	48 8b 95 50 02 00 00 	mov    rdx,QWORD PTR [rbp+0x250]
   183d0a03b:	48 8b 8d 60 02 00 00 	mov    rcx,QWORD PTR [rbp+0x260]
   183d0a042:	48 89 95 08 02 00 00 	mov    QWORD PTR [rbp+0x208],rdx
   183d0a049:	48 89 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],rax
   183d0a050:	0f 28 85 60 02 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x260]
   183d0a057:	0f 11 85 18 02 00 00 	movups XMMWORD PTR [rbp+0x218],xmm0
   183d0a05e:	48 85 c9             	test   rcx,rcx
   183d0a061:	74 03                	je     0x183d0a066
   183d0a063:	f0 ff 01             	lock inc DWORD PTR [rcx]
   183d0a066:	48 8d 95 f0 01 00 00 	lea    rdx,[rbp+0x1f0]
   183d0a06d:	48 89 95 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rdx
   183d0a074:	48 89 f1             	mov    rcx,rsi
   183d0a077:	e8 14 4b 47 fe       	call   0x18217eb90
   183d0a07c:	90                   	nop
   183d0a07d:	48 8d 8d c8 00 00 00 	lea    rcx,[rbp+0xc8]
   183d0a084:	48 89 c2             	mov    rdx,rax
   183d0a087:	e8 f4 6a 00 00       	call   0x183d10b80
   183d0a08c:	90                   	nop
   183d0a08d:	48 8d 4d a0          	lea    rcx,[rbp-0x60]
   183d0a091:	e8 aa fa cc fc       	call   0x1809d9b40
   183d0a096:	90                   	nop
   183d0a097:	48 8d 8d c8 00 00 00 	lea    rcx,[rbp+0xc8]
   183d0a09e:	e8 dd 4c 47 fe       	call   0x18217ed80
   183d0a0a3:	90                   	nop
   183d0a0a4:	48 89 c1             	mov    rcx,rax
   183d0a0a7:	48 05 30 01 00 00    	add    rax,0x130
   183d0a0ad:	48 8b 91 30 01 00 00 	mov    rdx,QWORD PTR [rcx+0x130]
   183d0a0b4:	48 89 c1             	mov    rcx,rax
   183d0a0b7:	ff 52 08             	call   QWORD PTR [rdx+0x8]
   183d0a0ba:	90                   	nop
   183d0a0bb:	48 8d 8d c8 00 00 00 	lea    rcx,[rbp+0xc8]
   183d0a0c2:	e8 79 fa cc fc       	call   0x1809d9b40
   183d0a0c7:	48 8b 85 60 02 00 00 	mov    rax,QWORD PTR [rbp+0x260]
   183d0a0ce:	48 85 c0             	test   rax,rax
   183d0a0d1:	74 58                	je     0x183d0a12b
   183d0a0d3:	f0 ff 08             	lock dec DWORD PTR [rax]
   183d0a0d6:	75 53                	jne    0x183d0a12b
   183d0a0d8:	48 8b b5 60 02 00 00 	mov    rsi,QWORD PTR [rbp+0x260]
   183d0a0df:	48 85 f6             	test   rsi,rsi
   183d0a0e2:	74 47                	je     0x183d0a12b
   183d0a0e4:	8b 06                	mov    eax,DWORD PTR [rsi]
   183d0a0e6:	85 c0                	test   eax,eax
   183d0a0e8:	74 19                	je     0x183d0a103
   183d0a0ea:	48 8d 0d 97 fb 07 05 	lea    rcx,[rip+0x507fb97]        # 0x188d89c88
   183d0a0f1:	48 8d 15 48 fb 07 05 	lea    rdx,[rip+0x507fb48]        # 0x188d89c40
   183d0a0f8:	41 b8 93 00 00 00    	mov    r8d,0x93
   183d0a0fe:	e8 5d 1c 44 fc       	call   0x18014bd60
   183d0a103:	8b 46 04             	mov    eax,DWORD PTR [rsi+0x4]
   183d0a106:	85 c0                	test   eax,eax
   183d0a108:	7e 19                	jle    0x183d0a123
   183d0a10a:	48 8d 0d 8f fb 07 05 	lea    rcx,[rip+0x507fb8f]        # 0x188d89ca0
   183d0a111:	48 8d 15 28 fb 07 05 	lea    rdx,[rip+0x507fb28]        # 0x188d89c40
   183d0a118:	41 b8 93 00 00 00    	mov    r8d,0x93
   183d0a11e:	e8 3d 1c 44 fc       	call   0x18014bd60
   183d0a123:	48 89 f1             	mov    rcx,rsi
   183d0a126:	e8 ad 17 7a 03       	call   0x1874ab8d8
   183d0a12b:	48 8b b5 58 02 00 00 	mov    rsi,QWORD PTR [rbp+0x258]
   183d0a132:	48 85 f6             	test   rsi,rsi
   183d0a135:	74 1d                	je     0x183d0a154
   183d0a137:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   183d0a13b:	75 17                	jne    0x183d0a154
   183d0a13d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183d0a140:	48 89 f1             	mov    rcx,rsi
   183d0a143:	ff 10                	call   QWORD PTR [rax]
   183d0a145:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   183d0a149:	75 09                	jne    0x183d0a154
   183d0a14b:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183d0a14e:	48 89 f1             	mov    rcx,rsi
   183d0a151:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183d0a154:	48 8d 8d 40 02 00 00 	lea    rcx,[rbp+0x240]
   183d0a15b:	e8 30 31 9a fc       	call   0x1806ad290
   183d0a160:	48 8b b5 88 02 00 00 	mov    rsi,QWORD PTR [rbp+0x288]
   183d0a167:	48 85 f6             	test   rsi,rsi
   183d0a16a:	74 1d                	je     0x183d0a189
   183d0a16c:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   183d0a170:	75 17                	jne    0x183d0a189
   183d0a172:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183d0a175:	48 89 f1             	mov    rcx,rsi
   183d0a178:	ff 10                	call   QWORD PTR [rax]
   183d0a17a:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   183d0a17e:	75 09                	jne    0x183d0a189
   183d0a180:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183d0a183:	48 89 f1             	mov    rcx,rsi
   183d0a186:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183d0a189:	48 8b 85 90 02 00 00 	mov    rax,QWORD PTR [rbp+0x290]
   183d0a190:	48 8b 00             	mov    rax,QWORD PTR [rax]
   183d0a193:	48 85 c0             	test   rax,rax
   183d0a196:	74 5b                	je     0x183d0a1f3
   183d0a198:	f0 ff 08             	lock dec DWORD PTR [rax]
   183d0a19b:	75 56                	jne    0x183d0a1f3
   183d0a19d:	48 8b 85 90 02 00 00 	mov    rax,QWORD PTR [rbp+0x290]
   183d0a1a4:	48 8b 30             	mov    rsi,QWORD PTR [rax]
   183d0a1a7:	48 85 f6             	test   rsi,rsi
   183d0a1aa:	74 47                	je     0x183d0a1f3
   183d0a1ac:	8b 06                	mov    eax,DWORD PTR [rsi]
   183d0a1ae:	85 c0                	test   eax,eax
   183d0a1b0:	74 19                	je     0x183d0a1cb
   183d0a1b2:	48 8d 0d cf fa 07 05 	lea    rcx,[rip+0x507facf]        # 0x188d89c88
   183d0a1b9:	48 8d 15 80 fa 07 05 	lea    rdx,[rip+0x507fa80]        # 0x188d89c40
   183d0a1c0:	41 b8 93 00 00 00    	mov    r8d,0x93
   183d0a1c6:	e8 95 1b 44 fc       	call   0x18014bd60
   183d0a1cb:	8b 46 04             	mov    eax,DWORD PTR [rsi+0x4]
   183d0a1ce:	85 c0                	test   eax,eax
   183d0a1d0:	7e 19                	jle    0x183d0a1eb
   183d0a1d2:	48 8d 0d c7 fa 07 05 	lea    rcx,[rip+0x507fac7]        # 0x188d89ca0
   183d0a1d9:	48 8d 15 60 fa 07 05 	lea    rdx,[rip+0x507fa60]        # 0x188d89c40
   183d0a1e0:	41 b8 93 00 00 00    	mov    r8d,0x93
   183d0a1e6:	e8 75 1b 44 fc       	call   0x18014bd60
   183d0a1eb:	48 89 f1             	mov    rcx,rsi
   183d0a1ee:	e8 e5 16 7a 03       	call   0x1874ab8d8
   183d0a1f3:	48 8b 95 78 02 00 00 	mov    rdx,QWORD PTR [rbp+0x278]
   183d0a1fa:	48 8b 0a             	mov    rcx,QWORD PTR [rdx]
   183d0a1fd:	8b 01                	mov    eax,DWORD PTR [rcx]
   183d0a1ff:	83 f8 ff             	cmp    eax,0xffffffff
   183d0a202:	74 1c                	je     0x183d0a220
   183d0a204:	85 c0                	test   eax,eax
   183d0a206:	74 08                	je     0x183d0a210
   183d0a208:	f0 ff 09             	lock dec DWORD PTR [rcx]
   183d0a20b:	75 13                	jne    0x183d0a220
   183d0a20d:	48 8b 0a             	mov    rcx,QWORD PTR [rdx]
   183d0a210:	ba 02 00 00 00       	mov    edx,0x2
   183d0a215:	41 b8 08 00 00 00    	mov    r8d,0x8
   183d0a21b:	e8 10 e7 32 fc       	call   0x180038930
   183d0a220:	0f 28 b5 a0 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x2a0]
   183d0a227:	48 81 c4 30 03 00 00 	add    rsp,0x330
   183d0a22e:	5b                   	pop    rbx
   183d0a22f:	5f                   	pop    rdi
   183d0a230:	5e                   	pop    rsi
   183d0a231:	41 5e                	pop    r14
   183d0a233:	5d                   	pop    rbp
   183d0a234:	c3                   	ret
   183d0a235:	e8 52 31 80 03       	call   0x18750d38c
   183d0a23a:	cc                   	int3
