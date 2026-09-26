
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001858f67b0 <.text+0x58f57b0>:
   1858f67b0:	55                   	push   rbp
   1858f67b1:	41 56                	push   r14
   1858f67b3:	56                   	push   rsi
   1858f67b4:	57                   	push   rdi
   1858f67b5:	53                   	push   rbx
   1858f67b6:	48 83 ec 40          	sub    rsp,0x40
   1858f67ba:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   1858f67bf:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1858f67c6:	ff 
   1858f67c7:	48 89 d7             	mov    rdi,rdx
   1858f67ca:	48 89 ce             	mov    rsi,rcx
   1858f67cd:	0f 28 05 dc f3 44 03 	movaps xmm0,XMMWORD PTR [rip+0x344f3dc]        # 0x188d45bb0
   1858f67d4:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   1858f67d8:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   1858f67dc:	e8 8f e4 df fa       	call   0x1806f4c70
   1858f67e1:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   1858f67e5:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   1858f67ec:	00 00 00 
   1858f67ef:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   1858f67f6:	48 39 fb             	cmp    rbx,rdi
   1858f67f9:	74 4e                	je     0x1858f6849
   1858f67fb:	4c 8b 77 10          	mov    r14,QWORD PTR [rdi+0x10]
   1858f67ff:	48 83 7f 18 10       	cmp    QWORD PTR [rdi+0x18],0x10
   1858f6804:	72 03                	jb     0x1858f6809
   1858f6806:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1858f6809:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1858f6810:	49 39 ce             	cmp    r14,rcx
   1858f6813:	76 11                	jbe    0x1858f6826
   1858f6815:	48 89 d9             	mov    rcx,rbx
   1858f6818:	4c 89 f2             	mov    rdx,r14
   1858f681b:	49 89 f9             	mov    r9,rdi
   1858f681e:	e8 2d 79 74 fa       	call   0x18003e150
   1858f6823:	90                   	nop
   1858f6824:	eb 23                	jmp    0x1858f6849
   1858f6826:	48 83 f9 10          	cmp    rcx,0x10
   1858f682a:	72 03                	jb     0x1858f682f
   1858f682c:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1858f682f:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1858f6836:	48 89 d9             	mov    rcx,rbx
   1858f6839:	48 89 fa             	mov    rdx,rdi
   1858f683c:	4d 89 f0             	mov    r8,r14
   1858f683f:	e8 0c d8 c4 01       	call   0x187544050
   1858f6844:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1858f6849:	e8 c2 f4 74 fa       	call   0x180045d10
   1858f684e:	90                   	nop
   1858f684f:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   1858f6852:	48 89 c1             	mov    rcx,rax
   1858f6855:	ff 52 20             	call   QWORD PTR [rdx+0x20]
   1858f6858:	90                   	nop
   1858f6859:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   1858f685d:	48 8d b9 b0 00 00 00 	lea    rdi,[rcx+0xb0]
   1858f6864:	48 39 c7             	cmp    rdi,rax
   1858f6867:	74 4d                	je     0x1858f68b6
   1858f6869:	48 8b 58 10          	mov    rbx,QWORD PTR [rax+0x10]
   1858f686d:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1858f6872:	72 03                	jb     0x1858f6877
   1858f6874:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1858f6877:	48 8b 91 c8 00 00 00 	mov    rdx,QWORD PTR [rcx+0xc8]
   1858f687e:	48 39 d3             	cmp    rbx,rdx
   1858f6881:	76 11                	jbe    0x1858f6894
   1858f6883:	48 89 f9             	mov    rcx,rdi
   1858f6886:	48 89 da             	mov    rdx,rbx
   1858f6889:	49 89 c1             	mov    r9,rax
   1858f688c:	e8 bf 78 74 fa       	call   0x18003e150
   1858f6891:	90                   	nop
   1858f6892:	eb 22                	jmp    0x1858f68b6
   1858f6894:	48 83 fa 10          	cmp    rdx,0x10
   1858f6898:	72 03                	jb     0x1858f689d
   1858f689a:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1858f689d:	48 89 99 c0 00 00 00 	mov    QWORD PTR [rcx+0xc0],rbx
   1858f68a4:	48 89 f9             	mov    rcx,rdi
   1858f68a7:	48 89 c2             	mov    rdx,rax
   1858f68aa:	49 89 d8             	mov    r8,rbx
   1858f68ad:	e8 9e d7 c4 01       	call   0x187544050
   1858f68b2:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   1858f68b6:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   1858f68ba:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   1858f68bd:	48 89 f0             	mov    rax,rsi
   1858f68c0:	48 83 c4 40          	add    rsp,0x40
   1858f68c4:	5b                   	pop    rbx
   1858f68c5:	5f                   	pop    rdi
   1858f68c6:	5e                   	pop    rsi
   1858f68c7:	41 5e                	pop    r14
   1858f68c9:	5d                   	pop    rbp
   1858f68ca:	c3                   	ret
