
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e83940 <.text+0x2e82940>:
   182e83940:	55                   	push   rbp
   182e83941:	56                   	push   rsi
   182e83942:	57                   	push   rdi
   182e83943:	53                   	push   rbx
   182e83944:	48 83 ec 68          	sub    rsp,0x68
   182e83948:	48 8d 6c 24 60       	lea    rbp,[rsp+0x60]
   182e8394d:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   182e83954:	ff 
   182e83955:	48 89 d7             	mov    rdi,rdx
   182e83958:	48 89 ce             	mov    rsi,rcx
   182e8395b:	48 39 ca             	cmp    rdx,rcx
   182e8395e:	75 45                	jne    0x182e839a5
   182e83960:	4c 8d 05 09 14 55 06 	lea    r8,[rip+0x6551409]        # 0x1893d4d70
   182e83967:	48 8d 5d c0          	lea    rbx,[rbp-0x40]
   182e8396b:	48 89 d9             	mov    rcx,rbx
   182e8396e:	ba 03 00 00 00       	mov    edx,0x3
   182e83973:	41 b9 56 03 00 00    	mov    r9d,0x356
   182e83979:	e8 02 e2 76 fe       	call   0x1815f1b80
   182e8397e:	90                   	nop
   182e8397f:	48 8d 15 d2 8c fb 05 	lea    rdx,[rip+0x5fb8cd2]        # 0x188e3c658
   182e83986:	48 89 d9             	mov    rcx,rbx
   182e83989:	e8 22 e2 76 fe       	call   0x1815f1bb0
   182e8398e:	90                   	nop
   182e8398f:	48 8d 4d ff          	lea    rcx,[rbp-0x1]
   182e83993:	48 89 c2             	mov    rdx,rax
   182e83996:	e8 35 e4 76 fe       	call   0x1815f1dd0
   182e8399b:	90                   	nop
   182e8399c:	48 8d 4d c0          	lea    rcx,[rbp-0x40]
   182e839a0:	e8 3b e4 76 fe       	call   0x1815f1de0
   182e839a5:	48 8d 4e 08          	lea    rcx,[rsi+0x8]
   182e839a9:	48 8d 57 08          	lea    rdx,[rdi+0x8]
   182e839ad:	e8 8e 5f 00 00       	call   0x182e89940
   182e839b2:	f6 47 28 01          	test   BYTE PTR [rdi+0x28],0x1
   182e839b6:	74 0a                	je     0x182e839c2
   182e839b8:	8b 47 20             	mov    eax,DWORD PTR [rdi+0x20]
   182e839bb:	83 4e 28 01          	or     DWORD PTR [rsi+0x28],0x1
   182e839bf:	89 46 20             	mov    DWORD PTR [rsi+0x20],eax
   182e839c2:	48 83 c4 68          	add    rsp,0x68
   182e839c6:	5b                   	pop    rbx
   182e839c7:	5f                   	pop    rdi
   182e839c8:	5e                   	pop    rsi
   182e839c9:	5d                   	pop    rbp
   182e839ca:	c3                   	ret
