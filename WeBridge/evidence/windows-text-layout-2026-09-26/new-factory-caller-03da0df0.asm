
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000183da0df0 <.text+0x3d9fdf0>:
   183da0df0:	55                   	push   rbp
   183da0df1:	41 57                	push   r15
   183da0df3:	41 56                	push   r14
   183da0df5:	41 54                	push   r12
   183da0df7:	56                   	push   rsi
   183da0df8:	57                   	push   rdi
   183da0df9:	53                   	push   rbx
   183da0dfa:	48 81 ec b0 03 00 00 	sub    rsp,0x3b0
   183da0e01:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   183da0e08:	00 
   183da0e09:	0f 29 b5 20 03 00 00 	movaps XMMWORD PTR [rbp+0x320],xmm6
   183da0e10:	48 c7 85 18 03 00 00 	mov    QWORD PTR [rbp+0x318],0xfffffffffffffffe
   183da0e17:	fe ff ff ff 
   183da0e1b:	48 89 d7             	mov    rdi,rdx
   183da0e1e:	48 89 ce             	mov    rsi,rcx
   183da0e21:	0f 28 35 88 4d fa 04 	movaps xmm6,XMMWORD PTR [rip+0x4fa4d88]        # 0x188d45bb0
   183da0e28:	0f 29 b5 00 03 00 00 	movaps XMMWORD PTR [rbp+0x300],xmm6
   183da0e2f:	48 8d 8d 00 03 00 00 	lea    rcx,[rbp+0x300]
   183da0e36:	e8 35 3e 95 fc       	call   0x1806f4c70
   183da0e3b:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   183da0e42:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   183da0e49:	00 00 00 
   183da0e4c:	48 89 f9             	mov    rcx,rdi
   183da0e4f:	e8 5c ff c7 fc       	call   0x180a20db0
   183da0e54:	90                   	nop
   183da0e55:	84 c0                	test   al,al
   183da0e57:	75 11                	jne    0x183da0e6a
   183da0e59:	48 89 f9             	mov    rcx,rdi
   183da0e5c:	e8 ff 07 c8 fc       	call   0x180a21660
   183da0e61:	90                   	nop
   183da0e62:	84 c0                	test   al,al
   183da0e64:	0f 84 97 01 00 00    	je     0x183da1001
   183da0e6a:	48 8d 9d 10 01 00 00 	lea    rbx,[rbp+0x110]
   183da0e71:	48 89 d9             	mov    rcx,rbx
   183da0e74:	48 89 fa             	mov    rdx,rdi
   183da0e77:	e8 24 08 c8 fc       	call   0x180a216a0
   183da0e7c:	90                   	nop
   183da0e7d:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   183da0e84:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   183da0e8b:	48 39 df             	cmp    rdi,rbx
   183da0e8e:	74 58                	je     0x183da0ee8
   183da0e90:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   183da0e97:	48 83 f8 10          	cmp    rax,0x10
   183da0e9b:	72 34                	jb     0x183da0ed1
   183da0e9d:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   183da0ea0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183da0ea4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183da0eab:	72 1f                	jb     0x183da0ecc
   183da0ead:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183da0eb1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183da0eb5:	4c 29 c1             	sub    rcx,r8
   183da0eb8:	48 83 f9 20          	cmp    rcx,0x20
   183da0ebc:	0f 83 27 0d 00 00    	jae    0x183da1be9
   183da0ec2:	48 83 c0 28          	add    rax,0x28
   183da0ec6:	48 89 c2             	mov    rdx,rax
   183da0ec9:	4c 89 c1             	mov    rcx,r8
   183da0ecc:	e8 0f aa 70 03       	call   0x1874ab8e0
   183da0ed1:	0f 10 85 10 01 00 00 	movups xmm0,XMMWORD PTR [rbp+0x110]
   183da0ed8:	0f 10 8d 20 01 00 00 	movups xmm1,XMMWORD PTR [rbp+0x120]
   183da0edf:	0f 11 4f 10          	movups XMMWORD PTR [rdi+0x10],xmm1
   183da0ee3:	0f 11 07             	movups XMMWORD PTR [rdi],xmm0
   183da0ee6:	eb 45                	jmp    0x183da0f2d
   183da0ee8:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   183da0eef:	48 83 f8 10          	cmp    rax,0x10
   183da0ef3:	72 38                	jb     0x183da0f2d
   183da0ef5:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   183da0efc:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183da0f00:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183da0f07:	72 1f                	jb     0x183da0f28
   183da0f09:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183da0f0d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183da0f11:	4c 29 c1             	sub    rcx,r8
   183da0f14:	48 83 f9 20          	cmp    rcx,0x20
   183da0f18:	0f 83 cb 0c 00 00    	jae    0x183da1be9
   183da0f1e:	48 83 c0 28          	add    rax,0x28
   183da0f22:	48 89 c2             	mov    rdx,rax
   183da0f25:	4c 89 c1             	mov    rcx,r8
   183da0f28:	e8 b3 a9 70 03       	call   0x1874ab8e0
   183da0f2d:	0f 57 c0             	xorps  xmm0,xmm0
   183da0f30:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   183da0f37:	48 c7 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],0x1
   183da0f3e:	01 00 00 00 
   183da0f42:	48 c7 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],0xf
   183da0f49:	0f 00 00 00 
   183da0f4d:	c6 85 10 01 00 00 0a 	mov    BYTE PTR [rbp+0x110],0xa
   183da0f54:	b9 58 07 00 00       	mov    ecx,0x758
   183da0f59:	48 03 8d 00 03 00 00 	add    rcx,QWORD PTR [rbp+0x300]
   183da0f60:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   183da0f67:	e8 e4 9b 46 fc       	call   0x18020ab50
   183da0f6c:	90                   	nop
   183da0f6d:	89 c3                	mov    ebx,eax
   183da0f6f:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   183da0f76:	48 83 f8 10          	cmp    rax,0x10
   183da0f7a:	72 38                	jb     0x183da0fb4
   183da0f7c:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   183da0f83:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183da0f87:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183da0f8e:	72 1f                	jb     0x183da0faf
   183da0f90:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183da0f94:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183da0f98:	4c 29 c1             	sub    rcx,r8
   183da0f9b:	48 83 f9 20          	cmp    rcx,0x20
   183da0f9f:	0f 83 44 0c 00 00    	jae    0x183da1be9
   183da0fa5:	48 83 c0 28          	add    rax,0x28
   183da0fa9:	48 89 c2             	mov    rdx,rax
   183da0fac:	4c 89 c1             	mov    rcx,r8
   183da0faf:	e8 2c a9 70 03       	call   0x1874ab8e0
   183da0fb4:	84 db                	test   bl,bl
   183da0fb6:	0f 85 e5 00 00 00    	jne    0x183da10a1
   183da0fbc:	48 8b 95 00 03 00 00 	mov    rdx,QWORD PTR [rbp+0x300]
   183da0fc3:	48 8d 8a 58 07 00 00 	lea    rcx,[rdx+0x758]
   183da0fca:	48 8b 82 68 07 00 00 	mov    rax,QWORD PTR [rdx+0x768]
   183da0fd1:	4c 8b 82 70 07 00 00 	mov    r8,QWORD PTR [rdx+0x770]
   183da0fd8:	49 39 c0             	cmp    r8,rax
   183da0fdb:	0f 85 a6 00 00 00    	jne    0x183da1087
   183da0fe1:	48 c7 44 24 20 01 00 	mov    QWORD PTR [rsp+0x20],0x1
   183da0fe8:	00 00 
   183da0fea:	4c 8d 0d 27 bb fe 04 	lea    r9,[rip+0x4febb27]        # 0x188d8cb18
   183da0ff1:	ba 01 00 00 00       	mov    edx,0x1
   183da0ff6:	e8 c5 83 26 fc       	call   0x1800093c0
   183da0ffb:	90                   	nop
   183da0ffc:	e9 a0 00 00 00       	jmp    0x183da10a1
   183da1001:	48 89 f9             	mov    rcx,rdi
   183da1004:	e8 67 45 c8 fc       	call   0x180a25570
   183da1009:	90                   	nop
   183da100a:	84 c0                	test   al,al
   183da100c:	0f 84 38 02 00 00    	je     0x183da124a
   183da1012:	4c 8d 8f e0 00 00 00 	lea    r9,[rdi+0xe0]
   183da1019:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   183da1020:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   183da1027:	4c 39 cb             	cmp    rbx,r9
   183da102a:	74 34                	je     0x183da1060
   183da102c:	4c 8b b7 f0 00 00 00 	mov    r14,QWORD PTR [rdi+0xf0]
   183da1033:	48 83 bf f8 00 00 00 	cmp    QWORD PTR [rdi+0xf8],0x10
   183da103a:	10 
   183da103b:	72 07                	jb     0x183da1044
   183da103d:	4c 8b 8f e0 00 00 00 	mov    r9,QWORD PTR [rdi+0xe0]
   183da1044:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   183da104b:	49 39 ce             	cmp    r14,rcx
   183da104e:	0f 86 9d 02 00 00    	jbe    0x183da12f1
   183da1054:	48 89 d9             	mov    rcx,rbx
   183da1057:	4c 89 f2             	mov    rdx,r14
   183da105a:	e8 f1 d0 29 fc       	call   0x18003e150
   183da105f:	90                   	nop
   183da1060:	0f 29 b5 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm6
   183da1067:	48 8b 87 b8 02 00 00 	mov    rax,QWORD PTR [rdi+0x2b8]
   183da106e:	48 85 c0             	test   rax,rax
   183da1071:	0f 84 b4 02 00 00    	je     0x183da132b
   183da1077:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183da107b:	48 8b 87 b8 02 00 00 	mov    rax,QWORD PTR [rdi+0x2b8]
   183da1082:	e9 a6 02 00 00       	jmp    0x183da132d
   183da1087:	4c 8d 48 01          	lea    r9,[rax+0x1]
   183da108b:	4c 89 8a 68 07 00 00 	mov    QWORD PTR [rdx+0x768],r9
   183da1092:	49 83 f8 10          	cmp    r8,0x10
   183da1096:	72 03                	jb     0x183da109b
   183da1098:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   183da109b:	66 c7 04 01 0a 00    	mov    WORD PTR [rcx+rax*1],0xa
   183da10a1:	48 8b 46 30          	mov    rax,QWORD PTR [rsi+0x30]
   183da10a5:	48 8b 48 10          	mov    rcx,QWORD PTR [rax+0x10]
   183da10a9:	48 85 c9             	test   rcx,rcx
   183da10ac:	48 89 8d f8 02 00 00 	mov    QWORD PTR [rbp+0x2f8],rcx
   183da10b3:	74 0a                	je     0x183da10bf
   183da10b5:	48 8b 70 08          	mov    rsi,QWORD PTR [rax+0x8]
   183da10b9:	f0 ff 41 0c          	lock inc DWORD PTR [rcx+0xc]
   183da10bd:	eb 02                	jmp    0x183da10c1
   183da10bf:	31 f6                	xor    esi,esi
   183da10c1:	b9 18 00 00 00       	mov    ecx,0x18
   183da10c6:	e8 d1 a7 70 03       	call   0x1874ab89c
   183da10cb:	90                   	nop
   183da10cc:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   183da10d3:	00 00 00 
   183da10d6:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   183da10da:	48 8d 0d 67 5f fa 04 	lea    rcx,[rip+0x4fa5f67]        # 0x188d47048
   183da10e1:	48 89 08             	mov    QWORD PTR [rax],rcx
   183da10e4:	48 89 c1             	mov    rcx,rax
   183da10e7:	48 83 c1 10          	add    rcx,0x10
   183da10eb:	c6 40 10 00          	mov    BYTE PTR [rax+0x10],0x0
   183da10ef:	48 89 8d 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rcx
   183da10f6:	48 89 85 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rax
   183da10fd:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0x0
   183da1104:	00 00 00 00 
   183da1108:	48 c7 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],0x0
   183da110f:	00 00 00 00 
   183da1113:	0f 57 c0             	xorps  xmm0,xmm0
   183da1116:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   183da111d:	48 89 b5 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],rsi
   183da1124:	48 8b 85 f8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2f8]
   183da112b:	48 89 85 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],rax
   183da1132:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   183da1139:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da1140:	48 85 c0             	test   rax,rax
   183da1143:	74 0d                	je     0x183da1152
   183da1145:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183da1149:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da1150:	eb 02                	jmp    0x183da1154
   183da1152:	31 c0                	xor    eax,eax
   183da1154:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   183da115b:	48 89 8d 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rcx
   183da1162:	48 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rax
   183da1169:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da1170:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   183da1177:	e8 14 65 2b fc       	call   0x180057690
   183da117c:	90                   	nop
   183da117d:	48 8b b5 28 02 00 00 	mov    rsi,QWORD PTR [rbp+0x228]
   183da1184:	48 85 f6             	test   rsi,rsi
   183da1187:	74 1d                	je     0x183da11a6
   183da1189:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   183da118d:	75 17                	jne    0x183da11a6
   183da118f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da1192:	48 89 f1             	mov    rcx,rsi
   183da1195:	ff 10                	call   QWORD PTR [rax]
   183da1197:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   183da119b:	75 09                	jne    0x183da11a6
   183da119d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da11a0:	48 89 f1             	mov    rcx,rsi
   183da11a3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183da11a6:	48 8b 8d f0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1f0]
   183da11ad:	48 85 c9             	test   rcx,rcx
   183da11b0:	74 0c                	je     0x183da11be
   183da11b2:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   183da11b6:	75 06                	jne    0x183da11be
   183da11b8:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da11bb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183da11be:	48 8b 8d d8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d8]
   183da11c5:	48 85 c9             	test   rcx,rcx
   183da11c8:	74 13                	je     0x183da11dd
   183da11ca:	48 8d 85 a0 01 00 00 	lea    rax,[rbp+0x1a0]
   183da11d1:	48 39 c1             	cmp    rcx,rax
   183da11d4:	0f 95 c2             	setne  dl
   183da11d7:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da11da:	ff 50 20             	call   QWORD PTR [rax+0x20]
   183da11dd:	48 8b 8d 98 01 00 00 	mov    rcx,QWORD PTR [rbp+0x198]
   183da11e4:	48 85 c9             	test   rcx,rcx
   183da11e7:	74 13                	je     0x183da11fc
   183da11e9:	48 8d 85 60 01 00 00 	lea    rax,[rbp+0x160]
   183da11f0:	48 39 c1             	cmp    rcx,rax
   183da11f3:	0f 95 c2             	setne  dl
   183da11f6:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da11f9:	ff 50 20             	call   QWORD PTR [rax+0x20]
   183da11fc:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   183da1203:	48 85 c9             	test   rcx,rcx
   183da1206:	74 13                	je     0x183da121b
   183da1208:	48 8d 85 20 01 00 00 	lea    rax,[rbp+0x120]
   183da120f:	48 39 c1             	cmp    rcx,rax
   183da1212:	0f 95 c2             	setne  dl
   183da1215:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da1218:	ff 50 20             	call   QWORD PTR [rax+0x20]
   183da121b:	48 8b b5 18 01 00 00 	mov    rsi,QWORD PTR [rbp+0x118]
   183da1222:	48 85 f6             	test   rsi,rsi
   183da1225:	0f 84 84 00 00 00    	je     0x183da12af
   183da122b:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   183da122f:	75 7e                	jne    0x183da12af
   183da1231:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da1234:	48 89 f1             	mov    rcx,rsi
   183da1237:	ff 10                	call   QWORD PTR [rax]
   183da1239:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   183da123d:	75 70                	jne    0x183da12af
   183da123f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da1242:	48 89 f1             	mov    rcx,rsi
   183da1245:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183da1248:	eb 65                	jmp    0x183da12af
   183da124a:	48 89 f9             	mov    rcx,rdi
   183da124d:	e8 1e 31 c8 fc       	call   0x180a24370
   183da1252:	90                   	nop
   183da1253:	84 c0                	test   al,al
   183da1255:	74 58                	je     0x183da12af
   183da1257:	0f 29 b5 c0 02 00 00 	movaps XMMWORD PTR [rbp+0x2c0],xmm6
   183da125e:	48 8b 8f a0 02 00 00 	mov    rcx,QWORD PTR [rdi+0x2a0]
   183da1265:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   183da126c:	00 
   183da126d:	4c 8d 05 0c 7a 31 07 	lea    r8,[rip+0x7317a0c]        # 0x18b0b8c80
   183da1274:	4c 8d 0d 35 7a 31 07 	lea    r9,[rip+0x7317a35]        # 0x18b0b8cb0
   183da127b:	31 d2                	xor    edx,edx
   183da127d:	e8 6a 27 75 03       	call   0x1874f39ec
   183da1282:	90                   	nop
   183da1283:	48 89 c3             	mov    rbx,rax
   183da1286:	48 85 c0             	test   rax,rax
   183da1289:	0f 84 10 01 00 00    	je     0x183da139f
   183da128f:	48 8b 87 a8 02 00 00 	mov    rax,QWORD PTR [rdi+0x2a8]
   183da1296:	48 85 c0             	test   rax,rax
   183da1299:	0f 84 0f 04 00 00    	je     0x183da16ae
   183da129f:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183da12a3:	48 8b 87 a8 02 00 00 	mov    rax,QWORD PTR [rdi+0x2a8]
   183da12aa:	e9 01 04 00 00       	jmp    0x183da16b0
   183da12af:	48 8b b5 08 03 00 00 	mov    rsi,QWORD PTR [rbp+0x308]
   183da12b6:	48 85 f6             	test   rsi,rsi
   183da12b9:	74 1d                	je     0x183da12d8
   183da12bb:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   183da12bf:	75 17                	jne    0x183da12d8
   183da12c1:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da12c4:	48 89 f1             	mov    rcx,rsi
   183da12c7:	ff 10                	call   QWORD PTR [rax]
   183da12c9:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   183da12cd:	75 09                	jne    0x183da12d8
   183da12cf:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da12d2:	48 89 f1             	mov    rcx,rsi
   183da12d5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183da12d8:	0f 28 b5 20 03 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x320]
   183da12df:	48 81 c4 b0 03 00 00 	add    rsp,0x3b0
   183da12e6:	5b                   	pop    rbx
   183da12e7:	5f                   	pop    rdi
   183da12e8:	5e                   	pop    rsi
   183da12e9:	41 5c                	pop    r12
   183da12eb:	41 5e                	pop    r14
   183da12ed:	41 5f                	pop    r15
   183da12ef:	5d                   	pop    rbp
   183da12f0:	c3                   	ret
   183da12f1:	48 83 f9 10          	cmp    rcx,0x10
   183da12f5:	72 03                	jb     0x183da12fa
   183da12f7:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   183da12fa:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   183da1301:	48 89 d9             	mov    rcx,rbx
   183da1304:	4c 89 ca             	mov    rdx,r9
   183da1307:	4d 89 f0             	mov    r8,r14
   183da130a:	e8 41 2d 7a 03       	call   0x187544050
   183da130f:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   183da1314:	0f 29 b5 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm6
   183da131b:	48 8b 87 b8 02 00 00 	mov    rax,QWORD PTR [rdi+0x2b8]
   183da1322:	48 85 c0             	test   rax,rax
   183da1325:	0f 85 4c fd ff ff    	jne    0x183da1077
   183da132b:	31 c0                	xor    eax,eax
   183da132d:	48 8b 8f b0 02 00 00 	mov    rcx,QWORD PTR [rdi+0x2b0]
   183da1334:	48 89 8d 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rcx
   183da133b:	48 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rax
   183da1342:	48 85 c9             	test   rcx,rcx
   183da1345:	0f 84 b4 01 00 00    	je     0x183da14ff
   183da134b:	48 8b 79 30          	mov    rdi,QWORD PTR [rcx+0x30]
   183da134f:	48 85 ff             	test   rdi,rdi
   183da1352:	0f 84 a7 01 00 00    	je     0x183da14ff
   183da1358:	4c 8d 49 20          	lea    r9,[rcx+0x20]
   183da135c:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   183da1363:	48 8d 98 78 07 00 00 	lea    rbx,[rax+0x778]
   183da136a:	4c 39 cb             	cmp    rbx,r9
   183da136d:	0f 84 8c 01 00 00    	je     0x183da14ff
   183da1373:	48 83 79 38 10       	cmp    QWORD PTR [rcx+0x38],0x10
   183da1378:	72 04                	jb     0x183da137e
   183da137a:	4c 8b 49 20          	mov    r9,QWORD PTR [rcx+0x20]
   183da137e:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   183da1385:	48 39 cf             	cmp    rdi,rcx
   183da1388:	0f 86 4f 01 00 00    	jbe    0x183da14dd
   183da138e:	48 89 d9             	mov    rcx,rbx
   183da1391:	48 89 fa             	mov    rdx,rdi
   183da1394:	e8 b7 cd 29 fc       	call   0x18003e150
   183da1399:	90                   	nop
   183da139a:	e9 60 01 00 00       	jmp    0x183da14ff
   183da139f:	0f 57 c0             	xorps  xmm0,xmm0
   183da13a2:	0f 29 85 c0 02 00 00 	movaps XMMWORD PTR [rbp+0x2c0],xmm0
   183da13a9:	b9 04 00 00 00       	mov    ecx,0x4
   183da13ae:	e8 2d ba 2c fc       	call   0x18006cde0
   183da13b3:	85 c0                	test   eax,eax
   183da13b5:	0f 84 22 08 00 00    	je     0x183da1bdd
   183da13bb:	48 8d b5 d0 02 00 00 	lea    rsi,[rbp+0x2d0]
   183da13c2:	48 89 f1             	mov    rcx,rsi
   183da13c5:	e8 46 bb 2c fc       	call   0x18006cf10
   183da13ca:	90                   	nop
   183da13cb:	48 83 bd e8 02 00 00 	cmp    QWORD PTR [rbp+0x2e8],0x10
   183da13d2:	10 
   183da13d3:	72 07                	jb     0x183da13dc
   183da13d5:	48 8b b5 d0 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2d0]
   183da13dc:	48 8d 05 ed 10 7e 05 	lea    rax,[rip+0x57e10ed]        # 0x1895824d0
   183da13e3:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   183da13e8:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   183da13ef:	00 00 
   183da13f1:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   183da13f6:	c7 44 24 28 7b 02 00 	mov    DWORD PTR [rsp+0x28],0x27b
   183da13fd:	00 
   183da13fe:	4c 8d 0d 4b 0c 7e 05 	lea    r9,[rip+0x57e0c4b]        # 0x189582050
   183da1405:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da140c:	ba 04 00 00 00       	mov    edx,0x4
   183da1411:	49 89 f0             	mov    r8,rsi
   183da1414:	e8 57 be 2c fc       	call   0x18006d270
   183da1419:	90                   	nop
   183da141a:	48 8d b5 a0 02 00 00 	lea    rsi,[rbp+0x2a0]
   183da1421:	48 89 f9             	mov    rcx,rdi
   183da1424:	48 89 f2             	mov    rdx,rsi
   183da1427:	e8 84 70 c7 fc       	call   0x180a184b0
   183da142c:	90                   	nop
   183da142d:	48 83 bd b8 02 00 00 	cmp    QWORD PTR [rbp+0x2b8],0x10
   183da1434:	10 
   183da1435:	72 07                	jb     0x183da143e
   183da1437:	48 8b b5 a0 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2a0]
   183da143e:	48 89 b5 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rsi
   183da1445:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   183da144c:	0f 57 c0             	xorps  xmm0,xmm0
   183da144f:	0f 11 85 88 02 00 00 	movups XMMWORD PTR [rbp+0x288],xmm0
   183da1456:	0f 11 85 78 02 00 00 	movups XMMWORD PTR [rbp+0x278],xmm0
   183da145d:	0f 11 85 68 02 00 00 	movups XMMWORD PTR [rbp+0x268],xmm0
   183da1464:	0f 11 85 58 02 00 00 	movups XMMWORD PTR [rbp+0x258],xmm0
   183da146b:	0f 11 85 48 02 00 00 	movups XMMWORD PTR [rbp+0x248],xmm0
   183da1472:	0f 11 85 38 02 00 00 	movups XMMWORD PTR [rbp+0x238],xmm0
   183da1479:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   183da1480:	48 c7 85 98 02 00 00 	mov    QWORD PTR [rbp+0x298],0x0
   183da1487:	00 00 00 00 
   183da148b:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   183da1492:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   183da1499:	48 8d 15 18 11 7e 05 	lea    rdx,[rip+0x57e1118]        # 0x1895825b8
   183da14a0:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da14a7:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   183da14ae:	e8 5d c3 2c fc       	call   0x18006d810
   183da14b3:	90                   	nop
   183da14b4:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   183da14bb:	e8 50 0b 26 fc       	call   0x180002010
   183da14c0:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da14c7:	e8 a4 be 2c fc       	call   0x18006d370
   183da14cc:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   183da14d3:	e8 38 0b 26 fc       	call   0x180002010
   183da14d8:	e9 00 07 00 00       	jmp    0x183da1bdd
   183da14dd:	48 83 f9 10          	cmp    rcx,0x10
   183da14e1:	72 03                	jb     0x183da14e6
   183da14e3:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   183da14e6:	48 89 b8 88 07 00 00 	mov    QWORD PTR [rax+0x788],rdi
   183da14ed:	48 89 d9             	mov    rcx,rbx
   183da14f0:	4c 89 ca             	mov    rdx,r9
   183da14f3:	49 89 f8             	mov    r8,rdi
   183da14f6:	e8 55 2b 7a 03       	call   0x187544050
   183da14fb:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   183da14ff:	48 8b 46 30          	mov    rax,QWORD PTR [rsi+0x30]
   183da1503:	48 8b 48 10          	mov    rcx,QWORD PTR [rax+0x10]
   183da1507:	48 85 c9             	test   rcx,rcx
   183da150a:	48 89 8d f8 02 00 00 	mov    QWORD PTR [rbp+0x2f8],rcx
   183da1511:	74 0a                	je     0x183da151d
   183da1513:	48 8b 70 08          	mov    rsi,QWORD PTR [rax+0x8]
   183da1517:	f0 ff 41 0c          	lock inc DWORD PTR [rcx+0xc]
   183da151b:	eb 02                	jmp    0x183da151f
   183da151d:	31 f6                	xor    esi,esi
   183da151f:	b9 18 00 00 00       	mov    ecx,0x18
   183da1524:	e8 73 a3 70 03       	call   0x1874ab89c
   183da1529:	90                   	nop
   183da152a:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   183da1531:	00 00 00 
   183da1534:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   183da1538:	48 8d 0d 09 5b fa 04 	lea    rcx,[rip+0x4fa5b09]        # 0x188d47048
   183da153f:	48 89 08             	mov    QWORD PTR [rax],rcx
   183da1542:	48 89 c1             	mov    rcx,rax
   183da1545:	48 83 c1 10          	add    rcx,0x10
   183da1549:	c6 40 10 00          	mov    BYTE PTR [rax+0x10],0x0
   183da154d:	48 89 8d 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rcx
   183da1554:	48 89 85 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rax
   183da155b:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0x0
   183da1562:	00 00 00 00 
   183da1566:	48 c7 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],0x0
   183da156d:	00 00 00 00 
   183da1571:	0f 57 c0             	xorps  xmm0,xmm0
   183da1574:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   183da157b:	48 89 b5 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],rsi
   183da1582:	48 8b 85 f8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2f8]
   183da1589:	48 89 85 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],rax
   183da1590:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   183da1597:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da159e:	48 85 c0             	test   rax,rax
   183da15a1:	74 0d                	je     0x183da15b0
   183da15a3:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183da15a7:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da15ae:	eb 02                	jmp    0x183da15b2
   183da15b0:	31 c0                	xor    eax,eax
   183da15b2:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   183da15b9:	48 89 8d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rcx
   183da15c0:	48 89 85 b8 00 00 00 	mov    QWORD PTR [rbp+0xb8],rax
   183da15c7:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da15ce:	48 8d 95 b0 00 00 00 	lea    rdx,[rbp+0xb0]
   183da15d5:	e8 b6 60 2b fc       	call   0x180057690
   183da15da:	90                   	nop
   183da15db:	48 8b b5 b8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb8]
   183da15e2:	48 85 f6             	test   rsi,rsi
   183da15e5:	74 1d                	je     0x183da1604
   183da15e7:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   183da15eb:	75 17                	jne    0x183da1604
   183da15ed:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da15f0:	48 89 f1             	mov    rcx,rsi
   183da15f3:	ff 10                	call   QWORD PTR [rax]
   183da15f5:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   183da15f9:	75 09                	jne    0x183da1604
   183da15fb:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da15fe:	48 89 f1             	mov    rcx,rsi
   183da1601:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183da1604:	48 8b 8d f0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1f0]
   183da160b:	48 85 c9             	test   rcx,rcx
   183da160e:	74 0c                	je     0x183da161c
   183da1610:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   183da1614:	75 06                	jne    0x183da161c
   183da1616:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da1619:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183da161c:	48 8b 8d d8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d8]
   183da1623:	48 85 c9             	test   rcx,rcx
   183da1626:	74 13                	je     0x183da163b
   183da1628:	48 8d 85 a0 01 00 00 	lea    rax,[rbp+0x1a0]
   183da162f:	48 39 c1             	cmp    rcx,rax
   183da1632:	0f 95 c2             	setne  dl
   183da1635:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da1638:	ff 50 20             	call   QWORD PTR [rax+0x20]
   183da163b:	48 8b 8d 98 01 00 00 	mov    rcx,QWORD PTR [rbp+0x198]
   183da1642:	48 85 c9             	test   rcx,rcx
   183da1645:	74 13                	je     0x183da165a
   183da1647:	48 8d 85 60 01 00 00 	lea    rax,[rbp+0x160]
   183da164e:	48 39 c1             	cmp    rcx,rax
   183da1651:	0f 95 c2             	setne  dl
   183da1654:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da1657:	ff 50 20             	call   QWORD PTR [rax+0x20]
   183da165a:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   183da1661:	48 85 c9             	test   rcx,rcx
   183da1664:	74 13                	je     0x183da1679
   183da1666:	48 8d 85 20 01 00 00 	lea    rax,[rbp+0x120]
   183da166d:	48 39 c1             	cmp    rcx,rax
   183da1670:	0f 95 c2             	setne  dl
   183da1673:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da1676:	ff 50 20             	call   QWORD PTR [rax+0x20]
   183da1679:	48 8b b5 18 01 00 00 	mov    rsi,QWORD PTR [rbp+0x118]
   183da1680:	48 85 f6             	test   rsi,rsi
   183da1683:	74 1d                	je     0x183da16a2
   183da1685:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   183da1689:	75 17                	jne    0x183da16a2
   183da168b:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da168e:	48 89 f1             	mov    rcx,rsi
   183da1691:	ff 10                	call   QWORD PTR [rax]
   183da1693:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   183da1697:	75 09                	jne    0x183da16a2
   183da1699:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   183da169c:	48 89 f1             	mov    rcx,rsi
   183da169f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183da16a2:	48 8b b5 28 02 00 00 	mov    rsi,QWORD PTR [rbp+0x228]
   183da16a9:	e9 74 fb ff ff       	jmp    0x183da1222
   183da16ae:	31 c0                	xor    eax,eax
   183da16b0:	48 89 9d c0 02 00 00 	mov    QWORD PTR [rbp+0x2c0],rbx
   183da16b7:	48 89 85 c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],rax
   183da16be:	0f 29 b5 e0 02 00 00 	movaps XMMWORD PTR [rbp+0x2e0],xmm6
   183da16c5:	0f 29 b5 d0 02 00 00 	movaps XMMWORD PTR [rbp+0x2d0],xmm6
   183da16cc:	48 89 d9             	mov    rcx,rbx
   183da16cf:	e8 3c 98 d1 fc       	call   0x180abaf10
   183da16d4:	90                   	nop
   183da16d5:	49 89 c6             	mov    r14,rax
   183da16d8:	0f 57 c0             	xorps  xmm0,xmm0
   183da16db:	0f 29 85 e0 02 00 00 	movaps XMMWORD PTR [rbp+0x2e0],xmm0
   183da16e2:	0f 29 85 d0 02 00 00 	movaps XMMWORD PTR [rbp+0x2d0],xmm0
   183da16e9:	4c 8b 78 10          	mov    r15,QWORD PTR [rax+0x10]
   183da16ed:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   183da16f2:	72 03                	jb     0x183da16f7
   183da16f4:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   183da16f7:	4d 85 ff             	test   r15,r15
   183da16fa:	0f 88 ef 04 00 00    	js     0x183da1bef
   183da1700:	49 83 ff 0f          	cmp    r15,0xf
   183da1704:	77 1f                	ja     0x183da1725
   183da1706:	4c 89 bd e0 02 00 00 	mov    QWORD PTR [rbp+0x2e0],r15
   183da170d:	48 c7 85 e8 02 00 00 	mov    QWORD PTR [rbp+0x2e8],0xf
   183da1714:	0f 00 00 00 
   183da1718:	41 0f 10 06          	movups xmm0,XMMWORD PTR [r14]
   183da171c:	0f 29 85 d0 02 00 00 	movaps XMMWORD PTR [rbp+0x2d0],xmm0
   183da1723:	eb 73                	jmp    0x183da1798
   183da1725:	4c 89 f8             	mov    rax,r15
   183da1728:	48 83 c8 0f          	or     rax,0xf
   183da172c:	48 83 f8 17          	cmp    rax,0x17
   183da1730:	41 bc 16 00 00 00    	mov    r12d,0x16
   183da1736:	4c 0f 43 e0          	cmovae r12,rax
   183da173a:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   183da1740:	72 25                	jb     0x183da1767
   183da1742:	49 8d 4c 24 28       	lea    rcx,[r12+0x28]
   183da1747:	e8 50 a1 70 03       	call   0x1874ab89c
   183da174c:	90                   	nop
   183da174d:	48 85 c0             	test   rax,rax
   183da1750:	0f 84 93 04 00 00    	je     0x183da1be9
   183da1756:	48 89 c1             	mov    rcx,rax
   183da1759:	48 83 c0 27          	add    rax,0x27
   183da175d:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   183da1761:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   183da1765:	eb 0b                	jmp    0x183da1772
   183da1767:	49 8d 4c 24 01       	lea    rcx,[r12+0x1]
   183da176c:	e8 2b a1 70 03       	call   0x1874ab89c
   183da1771:	90                   	nop
   183da1772:	48 89 85 d0 02 00 00 	mov    QWORD PTR [rbp+0x2d0],rax
   183da1779:	4c 89 bd e0 02 00 00 	mov    QWORD PTR [rbp+0x2e0],r15
   183da1780:	4c 89 a5 e8 02 00 00 	mov    QWORD PTR [rbp+0x2e8],r12
   183da1787:	49 ff c7             	inc    r15
   183da178a:	48 89 c1             	mov    rcx,rax
   183da178d:	4c 89 f2             	mov    rdx,r14
   183da1790:	4d 89 f8             	mov    r8,r15
   183da1793:	e8 b8 28 7a 03       	call   0x187544050
   183da1798:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   183da179f:	4c 8d b0 58 07 00 00 	lea    r14,[rax+0x758]
   183da17a6:	4c 8d 8d d0 02 00 00 	lea    r9,[rbp+0x2d0]
   183da17ad:	4d 39 ce             	cmp    r14,r9
   183da17b0:	74 55                	je     0x183da1807
   183da17b2:	4c 8b bd e0 02 00 00 	mov    r15,QWORD PTR [rbp+0x2e0]
   183da17b9:	48 83 bd e8 02 00 00 	cmp    QWORD PTR [rbp+0x2e8],0x10
   183da17c0:	10 
   183da17c1:	72 07                	jb     0x183da17ca
   183da17c3:	4c 8b 8d d0 02 00 00 	mov    r9,QWORD PTR [rbp+0x2d0]
   183da17ca:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   183da17d1:	49 39 cf             	cmp    r15,rcx
   183da17d4:	76 0e                	jbe    0x183da17e4
   183da17d6:	4c 89 f1             	mov    rcx,r14
   183da17d9:	4c 89 fa             	mov    rdx,r15
   183da17dc:	e8 6f c9 29 fc       	call   0x18003e150
   183da17e1:	90                   	nop
   183da17e2:	eb 23                	jmp    0x183da1807
   183da17e4:	48 83 f9 10          	cmp    rcx,0x10
   183da17e8:	72 03                	jb     0x183da17ed
   183da17ea:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   183da17ed:	4c 89 b8 68 07 00 00 	mov    QWORD PTR [rax+0x768],r15
   183da17f4:	4c 89 f1             	mov    rcx,r14
   183da17f7:	4c 89 ca             	mov    rdx,r9
   183da17fa:	4d 89 f8             	mov    r8,r15
   183da17fd:	e8 4e 28 7a 03       	call   0x187544050
   183da1802:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   183da1807:	48 89 d9             	mov    rcx,rbx
   183da180a:	48 81 c1 e8 06 00 00 	add    rcx,0x6e8
   183da1811:	e8 2a 2f c8 fc       	call   0x180a24740
   183da1816:	90                   	nop
   183da1817:	49 89 c6             	mov    r14,rax
   183da181a:	48 85 c0             	test   rax,rax
   183da181d:	0f 84 e9 00 00 00    	je     0x183da190c
   183da1823:	e8 e8 44 2a fc       	call   0x180045d10
   183da1828:	90                   	nop
   183da1829:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   183da182c:	48 8d 95 00 01 00 00 	lea    rdx,[rbp+0x100]
   183da1833:	48 89 c1             	mov    rcx,rax
   183da1836:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   183da183a:	90                   	nop
   183da183b:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   183da1842:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183da1845:	48 8d 95 00 02 00 00 	lea    rdx,[rbp+0x200]
   183da184c:	ff 50 30             	call   QWORD PTR [rax+0x30]
   183da184f:	90                   	nop
   183da1850:	48 8b 8d 00 02 00 00 	mov    rcx,QWORD PTR [rbp+0x200]
   183da1857:	48 8d 95 a0 02 00 00 	lea    rdx,[rbp+0x2a0]
   183da185e:	e8 fd 58 ff ff       	call   0x183d97160
   183da1863:	90                   	nop
   183da1864:	48 8b 8d a0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2a0]
   183da186b:	48 83 c7 70          	add    rdi,0x70
   183da186f:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   183da1876:	49 89 f8             	mov    r8,rdi
   183da1879:	4d 89 f1             	mov    r9,r14
   183da187c:	e8 0f 7a c0 fd       	call   0x1819a9290
   183da1881:	90                   	nop
   183da1882:	48 8d 15 ff 07 7e 05 	lea    rdx,[rip+0x57e07ff]        # 0x189582088
   183da1889:	4c 8d 05 c0 07 7e 05 	lea    r8,[rip+0x57e07c0]        # 0x189582050
   183da1890:	48 8d bd b0 00 00 00 	lea    rdi,[rbp+0xb0]
   183da1897:	48 89 f9             	mov    rcx,rdi
   183da189a:	41 b9 8a 02 00 00    	mov    r9d,0x28a
   183da18a0:	e8 5b 8c 3f fc       	call   0x18019a500
   183da18a5:	90                   	nop
   183da18a6:	48 c7 45 68 00 00 00 	mov    QWORD PTR [rbp+0x68],0x0
   183da18ad:	00 
   183da18ae:	48 c7 85 a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],0x0
   183da18b5:	00 00 00 00 
   183da18b9:	48 89 b5 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rsi
   183da18c0:	48 8d 8d 28 02 00 00 	lea    rcx,[rbp+0x228]
   183da18c7:	c6 85 16 03 00 00 01 	mov    BYTE PTR [rbp+0x316],0x1
   183da18ce:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   183da18d5:	e8 52 a5 70 03       	call   0x1874abe2c
   183da18da:	90                   	nop
   183da18db:	0f 57 c0             	xorps  xmm0,xmm0
   183da18de:	0f 11 85 48 02 00 00 	movups XMMWORD PTR [rbp+0x248],xmm0
   183da18e5:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da18ec:	48 85 c0             	test   rax,rax
   183da18ef:	0f 84 81 01 00 00    	je     0x183da1a76
   183da18f5:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183da18f9:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da1900:	48 8b 9d c0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2c0]
   183da1907:	e9 6c 01 00 00       	jmp    0x183da1a78
   183da190c:	b9 04 00 00 00       	mov    ecx,0x4
   183da1911:	e8 ca b4 2c fc       	call   0x18006cde0
   183da1916:	85 c0                	test   eax,eax
   183da1918:	0f 84 1e 01 00 00    	je     0x183da1a3c
   183da191e:	48 8d 9d a0 02 00 00 	lea    rbx,[rbp+0x2a0]
   183da1925:	48 89 d9             	mov    rcx,rbx
   183da1928:	e8 e3 b5 2c fc       	call   0x18006cf10
   183da192d:	90                   	nop
   183da192e:	48 83 bd b8 02 00 00 	cmp    QWORD PTR [rbp+0x2b8],0x10
   183da1935:	10 
   183da1936:	72 07                	jb     0x183da193f
   183da1938:	48 8b 9d a0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2a0]
   183da193f:	48 8d 05 8a 0b 7e 05 	lea    rax,[rip+0x57e0b8a]        # 0x1895824d0
   183da1946:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   183da194b:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   183da1952:	00 00 
   183da1954:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   183da1959:	c7 44 24 28 83 02 00 	mov    DWORD PTR [rsp+0x28],0x283
   183da1960:	00 
   183da1961:	4c 8d 0d e8 06 7e 05 	lea    r9,[rip+0x57e06e8]        # 0x189582050
   183da1968:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da196f:	ba 04 00 00 00       	mov    edx,0x4
   183da1974:	49 89 d8             	mov    r8,rbx
   183da1977:	e8 f4 b8 2c fc       	call   0x18006d270
   183da197c:	90                   	nop
   183da197d:	48 8d 9d 00 02 00 00 	lea    rbx,[rbp+0x200]
   183da1984:	48 89 f9             	mov    rcx,rdi
   183da1987:	48 89 da             	mov    rdx,rbx
   183da198a:	e8 21 6b c7 fc       	call   0x180a184b0
   183da198f:	90                   	nop
   183da1990:	48 83 bd 18 02 00 00 	cmp    QWORD PTR [rbp+0x218],0x10
   183da1997:	10 
   183da1998:	72 07                	jb     0x183da19a1
   183da199a:	48 8b 9d 00 02 00 00 	mov    rbx,QWORD PTR [rbp+0x200]
   183da19a1:	48 89 9d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rbx
   183da19a8:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   183da19af:	0f 57 c0             	xorps  xmm0,xmm0
   183da19b2:	0f 11 85 88 02 00 00 	movups XMMWORD PTR [rbp+0x288],xmm0
   183da19b9:	0f 11 85 78 02 00 00 	movups XMMWORD PTR [rbp+0x278],xmm0
   183da19c0:	0f 11 85 68 02 00 00 	movups XMMWORD PTR [rbp+0x268],xmm0
   183da19c7:	0f 11 85 58 02 00 00 	movups XMMWORD PTR [rbp+0x258],xmm0
   183da19ce:	0f 11 85 48 02 00 00 	movups XMMWORD PTR [rbp+0x248],xmm0
   183da19d5:	0f 11 85 38 02 00 00 	movups XMMWORD PTR [rbp+0x238],xmm0
   183da19dc:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   183da19e3:	48 c7 85 98 02 00 00 	mov    QWORD PTR [rbp+0x298],0x0
   183da19ea:	00 00 00 00 
   183da19ee:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   183da19f5:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   183da19fc:	48 8d 15 7d 08 7e 05 	lea    rdx,[rip+0x57e087d]        # 0x189582280
   183da1a03:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da1a0a:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   183da1a11:	e8 fa bd 2c fc       	call   0x18006d810
   183da1a16:	90                   	nop
   183da1a17:	48 8d 8d 00 02 00 00 	lea    rcx,[rbp+0x200]
   183da1a1e:	e8 ed 05 26 fc       	call   0x180002010
   183da1a23:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da1a2a:	e8 41 b9 2c fc       	call   0x18006d370
   183da1a2f:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   183da1a36:	e8 d5 05 26 fc       	call   0x180002010
   183da1a3b:	90                   	nop
   183da1a3c:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   183da1a43:	48 89 f1             	mov    rcx,rsi
   183da1a46:	e8 25 08 00 00       	call   0x183da2270
   183da1a4b:	90                   	nop
   183da1a4c:	0f 57 c0             	xorps  xmm0,xmm0
   183da1a4f:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   183da1a56:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da1a5d:	48 85 c0             	test   rax,rax
   183da1a60:	0f 84 23 01 00 00    	je     0x183da1b89
   183da1a66:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183da1a6a:	48 8b 85 08 03 00 00 	mov    rax,QWORD PTR [rbp+0x308]
   183da1a71:	e9 15 01 00 00       	jmp    0x183da1b8b
   183da1a76:	31 c0                	xor    eax,eax
   183da1a78:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   183da1a7f:	48 89 8d 48 02 00 00 	mov    QWORD PTR [rbp+0x248],rcx
   183da1a86:	48 89 85 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rax
   183da1a8d:	48 81 c3 38 07 00 00 	add    rbx,0x738
   183da1a94:	48 89 9d 58 02 00 00 	mov    QWORD PTR [rbp+0x258],rbx
   183da1a9b:	c6 85 17 03 00 00 01 	mov    BYTE PTR [rbp+0x317],0x1
   183da1aa2:	48 8d 4d c8          	lea    rcx,[rbp-0x38]
   183da1aa6:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   183da1aad:	e8 ae 08 00 00       	call   0x183da2360
   183da1ab2:	90                   	nop
   183da1ab3:	c6 85 17 03 00 00 00 	mov    BYTE PTR [rbp+0x317],0x0
   183da1aba:	48 89 7c 24 28       	mov    QWORD PTR [rsp+0x28],rdi
   183da1abf:	48 8d 45 30          	lea    rax,[rbp+0x30]
   183da1ac3:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   183da1ac8:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da1acf:	48 8d 55 08          	lea    rdx,[rbp+0x8]
   183da1ad3:	4c 8d 45 c8          	lea    r8,[rbp-0x38]
   183da1ad7:	4c 8d 4d 70          	lea    r9,[rbp+0x70]
   183da1adb:	e8 10 b1 71 fd       	call   0x1814bcbf0
   183da1ae0:	90                   	nop
   183da1ae1:	48 81 c6 d0 00 00 00 	add    rsi,0xd0
   183da1ae8:	c6 85 17 03 00 00 00 	mov    BYTE PTR [rbp+0x317],0x0
   183da1aef:	48 8d 55 08          	lea    rdx,[rbp+0x8]
   183da1af3:	48 89 f1             	mov    rcx,rsi
   183da1af6:	e8 c5 7a b6 fc       	call   0x1809095c0
   183da1afb:	90                   	nop
   183da1afc:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   183da1b03:	e8 88 8a 2b fc       	call   0x18005a590
   183da1b08:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da1b0f:	e8 4c a8 26 fc       	call   0x18000c360
   183da1b14:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   183da1b1b:	e8 40 05 26 fc       	call   0x180002060
   183da1b20:	48 8d 8d 00 02 00 00 	lea    rcx,[rbp+0x200]
   183da1b27:	e8 34 05 26 fc       	call   0x180002060
   183da1b2c:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   183da1b33:	e8 28 05 26 fc       	call   0x180002060
   183da1b38:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   183da1b3f:	48 83 f8 10          	cmp    rax,0x10
   183da1b43:	0f 82 94 00 00 00    	jb     0x183da1bdd
   183da1b49:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   183da1b50:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183da1b54:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183da1b5b:	72 1b                	jb     0x183da1b78
   183da1b5d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183da1b61:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183da1b65:	4c 29 c1             	sub    rcx,r8
   183da1b68:	48 83 f9 20          	cmp    rcx,0x20
   183da1b6c:	73 7b                	jae    0x183da1be9
   183da1b6e:	48 83 c0 28          	add    rax,0x28
   183da1b72:	48 89 c2             	mov    rdx,rax
   183da1b75:	4c 89 c1             	mov    rcx,r8
   183da1b78:	e8 63 9d 70 03       	call   0x1874ab8e0
   183da1b7d:	48 8b b5 c8 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2c8]
   183da1b84:	e9 99 f6 ff ff       	jmp    0x183da1222
   183da1b89:	31 c0                	xor    eax,eax
   183da1b8b:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   183da1b92:	48 89 8d 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rcx
   183da1b99:	48 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rax
   183da1ba0:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da1ba7:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   183da1bae:	e8 dd 5a 2b fc       	call   0x180057690
   183da1bb3:	90                   	nop
   183da1bb4:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   183da1bbb:	e8 a0 04 26 fc       	call   0x180002060
   183da1bc0:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   183da1bc7:	e8 d4 ce 26 fc       	call   0x18000eaa0
   183da1bcc:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   183da1bd3:	48 83 f8 10          	cmp    rax,0x10
   183da1bd7:	0f 83 6c ff ff ff    	jae    0x183da1b49
   183da1bdd:	48 8b b5 c8 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2c8]
   183da1be4:	e9 39 f6 ff ff       	jmp    0x183da1222
   183da1be9:	e8 9e b7 76 03       	call   0x18750d38c
   183da1bee:	90                   	nop
   183da1bef:	e8 9c 6f 26 fc       	call   0x180008b90
   183da1bf4:	90                   	nop
   183da1bf5:	cc                   	int3
