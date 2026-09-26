
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001819d1090 <.text+0x19d0090>:
   1819d1090:	41 56                	push   r14
   1819d1092:	56                   	push   rsi
   1819d1093:	57                   	push   rdi
   1819d1094:	53                   	push   rbx
   1819d1095:	48 83 ec 28          	sub    rsp,0x28
   1819d1099:	48 89 ce             	mov    rsi,rcx
   1819d109c:	48 8b 89 f8 00 00 00 	mov    rcx,QWORD PTR [rcx+0xf8]
   1819d10a3:	48 85 c9             	test   rcx,rcx
   1819d10a6:	74 0c                	je     0x1819d10b4
   1819d10a8:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   1819d10ac:	75 06                	jne    0x1819d10b4
   1819d10ae:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d10b1:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d10b4:	48 8b 8e e0 00 00 00 	mov    rcx,QWORD PTR [rsi+0xe0]
   1819d10bb:	48 85 c9             	test   rcx,rcx
   1819d10be:	74 13                	je     0x1819d10d3
   1819d10c0:	48 8d 86 a8 00 00 00 	lea    rax,[rsi+0xa8]
   1819d10c7:	48 39 c1             	cmp    rcx,rax
   1819d10ca:	0f 95 c2             	setne  dl
   1819d10cd:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d10d0:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1819d10d3:	48 8b 8e a0 00 00 00 	mov    rcx,QWORD PTR [rsi+0xa0]
   1819d10da:	48 85 c9             	test   rcx,rcx
   1819d10dd:	74 10                	je     0x1819d10ef
   1819d10df:	48 8d 46 68          	lea    rax,[rsi+0x68]
   1819d10e3:	48 39 c1             	cmp    rcx,rax
   1819d10e6:	0f 95 c2             	setne  dl
   1819d10e9:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d10ec:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1819d10ef:	48 8b 4e 60          	mov    rcx,QWORD PTR [rsi+0x60]
   1819d10f3:	48 85 c9             	test   rcx,rcx
   1819d10f6:	74 10                	je     0x1819d1108
   1819d10f8:	48 8d 46 28          	lea    rax,[rsi+0x28]
   1819d10fc:	48 39 c1             	cmp    rcx,rax
   1819d10ff:	0f 95 c2             	setne  dl
   1819d1102:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1819d1105:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1819d1108:	48 8b 7e 20          	mov    rdi,QWORD PTR [rsi+0x20]
   1819d110c:	48 85 ff             	test   rdi,rdi
   1819d110f:	74 1d                	je     0x1819d112e
   1819d1111:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1819d1115:	75 17                	jne    0x1819d112e
   1819d1117:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d111a:	48 89 f9             	mov    rcx,rdi
   1819d111d:	ff 10                	call   QWORD PTR [rax]
   1819d111f:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1819d1123:	75 09                	jne    0x1819d112e
   1819d1125:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d1128:	48 89 f9             	mov    rcx,rdi
   1819d112b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d112e:	48 8b 3e             	mov    rdi,QWORD PTR [rsi]
   1819d1131:	48 85 ff             	test   rdi,rdi
   1819d1134:	0f 84 93 00 00 00    	je     0x1819d11cd
   1819d113a:	4c 8b 76 08          	mov    r14,QWORD PTR [rsi+0x8]
   1819d113e:	4c 39 f7             	cmp    rdi,r14
   1819d1141:	75 26                	jne    0x1819d1169
   1819d1143:	48 8b 56 10          	mov    rdx,QWORD PTR [rsi+0x10]
   1819d1147:	48 29 fa             	sub    rdx,rdi
   1819d114a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1819d1151:	73 51                	jae    0x1819d11a4
   1819d1153:	eb 67                	jmp    0x1819d11bc
   1819d1155:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   1819d115c:	00 00 00 00 
   1819d1160:	48 83 c7 10          	add    rdi,0x10
   1819d1164:	4c 39 f7             	cmp    rdi,r14
   1819d1167:	74 28                	je     0x1819d1191
   1819d1169:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   1819d116d:	48 85 db             	test   rbx,rbx
   1819d1170:	74 ee                	je     0x1819d1160
   1819d1172:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1819d1176:	75 e8                	jne    0x1819d1160
   1819d1178:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1819d117b:	48 89 d9             	mov    rcx,rbx
   1819d117e:	ff 10                	call   QWORD PTR [rax]
   1819d1180:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1819d1184:	75 da                	jne    0x1819d1160
   1819d1186:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1819d1189:	48 89 d9             	mov    rcx,rbx
   1819d118c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d118f:	eb cf                	jmp    0x1819d1160
   1819d1191:	48 8b 3e             	mov    rdi,QWORD PTR [rsi]
   1819d1194:	48 8b 56 10          	mov    rdx,QWORD PTR [rsi+0x10]
   1819d1198:	48 29 fa             	sub    rdx,rdi
   1819d119b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1819d11a2:	72 18                	jb     0x1819d11bc
   1819d11a4:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   1819d11a8:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   1819d11ac:	48 29 c7             	sub    rdi,rax
   1819d11af:	48 83 ff 20          	cmp    rdi,0x20
   1819d11b3:	73 22                	jae    0x1819d11d7
   1819d11b5:	48 83 c2 27          	add    rdx,0x27
   1819d11b9:	48 89 c7             	mov    rdi,rax
   1819d11bc:	48 89 f9             	mov    rcx,rdi
   1819d11bf:	48 83 c4 28          	add    rsp,0x28
   1819d11c3:	5b                   	pop    rbx
   1819d11c4:	5f                   	pop    rdi
   1819d11c5:	5e                   	pop    rsi
   1819d11c6:	41 5e                	pop    r14
   1819d11c8:	e9 13 a7 ad 05       	jmp    0x1874ab8e0
   1819d11cd:	48 83 c4 28          	add    rsp,0x28
   1819d11d1:	5b                   	pop    rbx
   1819d11d2:	5f                   	pop    rdi
   1819d11d3:	5e                   	pop    rsi
   1819d11d4:	41 5e                	pop    r14
   1819d11d6:	c3                   	ret
   1819d11d7:	e8 b0 c1 b3 05       	call   0x18750d38c
   1819d11dc:	cc                   	int3
