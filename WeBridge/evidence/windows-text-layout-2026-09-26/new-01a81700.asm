
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181a81700 <.text+0x1a80700>:
   181a81700:	55                   	push   rbp
   181a81701:	56                   	push   rsi
   181a81702:	57                   	push   rdi
   181a81703:	53                   	push   rbx
   181a81704:	48 83 ec 38          	sub    rsp,0x38
   181a81708:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   181a8170d:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   181a81714:	ff 
   181a81715:	4c 89 c6             	mov    rsi,r8
   181a81718:	48 89 d7             	mov    rdi,rdx
   181a8171b:	48 89 cb             	mov    rbx,rcx
   181a8171e:	48 8d 15 5b 2e 6a 07 	lea    rdx,[rip+0x76a2e5b]        # 0x189124580
   181a81725:	41 b8 98 07 00 00    	mov    r8d,0x798
   181a8172b:	e8 20 29 ac 05       	call   0x187544050
   181a81730:	48 89 d9             	mov    rcx,rbx
   181a81733:	e8 48 4f ce fe       	call   0x180766680
   181a81738:	8b 05 1a ea ea 09    	mov    eax,DWORD PTR [rip+0x9eaea1a]        # 0x18b930158
   181a8173e:	8b 0d 5c 2a e9 09    	mov    ecx,DWORD PTR [rip+0x9e92a5c]        # 0x18b9141a0
   181a81744:	65 48 8b 14 25 58 00 	mov    rdx,QWORD PTR gs:0x58
   181a8174b:	00 00 
   181a8174d:	48 8b 0c ca          	mov    rcx,QWORD PTR [rdx+rcx*8]
   181a81751:	3b 81 c4 00 00 00    	cmp    eax,DWORD PTR [rcx+0xc4]
   181a81757:	48 89 5d f8          	mov    QWORD PTR [rbp-0x8],rbx
   181a8175b:	7f 23                	jg     0x181a81780
   181a8175d:	48 8b 15 ec e9 ea 09 	mov    rdx,QWORD PTR [rip+0x9eae9ec]        # 0x18b930150
   181a81764:	48 89 d9             	mov    rcx,rbx
   181a81767:	49 89 f8             	mov    r8,rdi
   181a8176a:	49 89 f1             	mov    r9,rsi
   181a8176d:	e8 ae 5e b6 ff       	call   0x1815e7620
   181a81772:	90                   	nop
   181a81773:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   181a81777:	48 83 c4 38          	add    rsp,0x38
   181a8177b:	5b                   	pop    rbx
   181a8177c:	5f                   	pop    rdi
   181a8177d:	5e                   	pop    rsi
   181a8177e:	5d                   	pop    rbp
   181a8177f:	c3                   	ret
   181a81780:	48 8d 0d d1 e9 ea 09 	lea    rcx,[rip+0x9eae9d1]        # 0x18b930158
   181a81787:	e8 a4 a1 a2 05       	call   0x1874ab930
   181a8178c:	83 3d c5 e9 ea 09 ff 	cmp    DWORD PTR [rip+0x9eae9c5],0xffffffff        # 0x18b930158
   181a81793:	75 c8                	jne    0x181a8175d
   181a81795:	e8 86 00 00 00       	call   0x181a81820
   181a8179a:	90                   	nop
   181a8179b:	48 89 05 ae e9 ea 09 	mov    QWORD PTR [rip+0x9eae9ae],rax        # 0x18b930150
   181a817a2:	48 8d 0d af e9 ea 09 	lea    rcx,[rip+0x9eae9af]        # 0x18b930158
   181a817a9:	e8 36 a2 a2 05       	call   0x1874ab9e4
   181a817ae:	48 8b 5d f8          	mov    rbx,QWORD PTR [rbp-0x8]
   181a817b2:	eb a9                	jmp    0x181a8175d
