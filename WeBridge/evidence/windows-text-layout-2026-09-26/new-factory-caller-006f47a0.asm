
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001806f47a0 <.text+0x6f37a0>:
   1806f47a0:	55                   	push   rbp
   1806f47a1:	41 57                	push   r15
   1806f47a3:	41 56                	push   r14
   1806f47a5:	56                   	push   rsi
   1806f47a6:	57                   	push   rdi
   1806f47a7:	53                   	push   rbx
   1806f47a8:	48 81 ec f8 00 00 00 	sub    rsp,0xf8
   1806f47af:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1806f47b6:	00 
   1806f47b7:	0f 29 75 60          	movaps XMMWORD PTR [rbp+0x60],xmm6
   1806f47bb:	48 c7 45 58 fe ff ff 	mov    QWORD PTR [rbp+0x58],0xfffffffffffffffe
   1806f47c2:	ff 
   1806f47c3:	48 89 d6             	mov    rsi,rdx
   1806f47c6:	0f 28 35 e3 13 65 08 	movaps xmm6,XMMWORD PTR [rip+0x86513e3]        # 0x188d45bb0
   1806f47cd:	0f 29 75 40          	movaps XMMWORD PTR [rbp+0x40],xmm6
   1806f47d1:	48 8d 4d 40          	lea    rcx,[rbp+0x40]
   1806f47d5:	e8 96 04 00 00       	call   0x1806f4c70
   1806f47da:	48 8b 45 40          	mov    rax,QWORD PTR [rbp+0x40]
   1806f47de:	48 8d b8 b0 00 00 00 	lea    rdi,[rax+0xb0]
   1806f47e5:	48 39 f7             	cmp    rdi,rsi
   1806f47e8:	74 4d                	je     0x1806f4837
   1806f47ea:	48 8b 5e 10          	mov    rbx,QWORD PTR [rsi+0x10]
   1806f47ee:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   1806f47f3:	72 03                	jb     0x1806f47f8
   1806f47f5:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1806f47f8:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   1806f47ff:	48 39 cb             	cmp    rbx,rcx
   1806f4802:	76 11                	jbe    0x1806f4815
   1806f4804:	48 89 f9             	mov    rcx,rdi
   1806f4807:	48 89 da             	mov    rdx,rbx
   1806f480a:	49 89 f1             	mov    r9,rsi
   1806f480d:	e8 3e 99 94 ff       	call   0x18003e150
   1806f4812:	90                   	nop
   1806f4813:	eb 22                	jmp    0x1806f4837
   1806f4815:	48 83 f9 10          	cmp    rcx,0x10
   1806f4819:	72 03                	jb     0x1806f481e
   1806f481b:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1806f481e:	48 89 98 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],rbx
   1806f4825:	48 89 f9             	mov    rcx,rdi
   1806f4828:	48 89 f2             	mov    rdx,rsi
   1806f482b:	49 89 d8             	mov    r8,rbx
   1806f482e:	e8 1d f8 e4 06       	call   0x187544050
   1806f4833:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   1806f4837:	48 8b 45 40          	mov    rax,QWORD PTR [rbp+0x40]
   1806f483b:	c7 80 18 01 00 00 10 	mov    DWORD PTR [rax+0x118],0x2710
   1806f4842:	27 00 00 
   1806f4845:	0f 29 75 30          	movaps XMMWORD PTR [rbp+0x30],xmm6
   1806f4849:	0f 29 75 20          	movaps XMMWORD PTR [rbp+0x20],xmm6
   1806f484d:	e8 ae b1 9d ff       	call   0x1800cfa00
   1806f4852:	90                   	nop
   1806f4853:	48 89 c6             	mov    rsi,rax
   1806f4856:	0f 57 c0             	xorps  xmm0,xmm0
   1806f4859:	0f 29 45 30          	movaps XMMWORD PTR [rbp+0x30],xmm0
   1806f485d:	0f 29 45 20          	movaps XMMWORD PTR [rbp+0x20],xmm0
   1806f4861:	48 89 c1             	mov    rcx,rax
   1806f4864:	e8 37 fd e2 06       	call   0x1875245a0
   1806f4869:	48 85 c0             	test   rax,rax
   1806f486c:	0f 88 a9 02 00 00    	js     0x1806f4b1b
   1806f4872:	48 89 c7             	mov    rdi,rax
   1806f4875:	4c 8d 75 20          	lea    r14,[rbp+0x20]
   1806f4879:	41 bf 0f 00 00 00    	mov    r15d,0xf
   1806f487f:	4c 89 f3             	mov    rbx,r14
   1806f4882:	48 83 f8 10          	cmp    rax,0x10
   1806f4886:	72 55                	jb     0x1806f48dd
   1806f4888:	48 89 f8             	mov    rax,rdi
   1806f488b:	48 83 c8 0f          	or     rax,0xf
   1806f488f:	48 83 f8 17          	cmp    rax,0x17
   1806f4893:	41 bf 16 00 00 00    	mov    r15d,0x16
   1806f4899:	4c 0f 43 f8          	cmovae r15,rax
   1806f489d:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1806f48a3:	72 27                	jb     0x1806f48cc
   1806f48a5:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   1806f48a9:	e8 ee 6f db 06       	call   0x1874ab89c
   1806f48ae:	90                   	nop
   1806f48af:	48 89 c3             	mov    rbx,rax
   1806f48b2:	48 85 c0             	test   rax,rax
   1806f48b5:	0f 84 66 02 00 00    	je     0x1806f4b21
   1806f48bb:	48 89 d8             	mov    rax,rbx
   1806f48be:	48 83 c3 27          	add    rbx,0x27
   1806f48c2:	48 83 e3 e0          	and    rbx,0xffffffffffffffe0
   1806f48c6:	48 89 43 f8          	mov    QWORD PTR [rbx-0x8],rax
   1806f48ca:	eb 0d                	jmp    0x1806f48d9
   1806f48cc:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1806f48d0:	e8 c7 6f db 06       	call   0x1874ab89c
   1806f48d5:	90                   	nop
   1806f48d6:	48 89 c3             	mov    rbx,rax
   1806f48d9:	48 89 5d 20          	mov    QWORD PTR [rbp+0x20],rbx
   1806f48dd:	48 89 7d 30          	mov    QWORD PTR [rbp+0x30],rdi
   1806f48e1:	4c 89 7d 38          	mov    QWORD PTR [rbp+0x38],r15
   1806f48e5:	48 89 d9             	mov    rcx,rbx
   1806f48e8:	48 89 f2             	mov    rdx,rsi
   1806f48eb:	49 89 f8             	mov    r8,rdi
   1806f48ee:	e8 5d f7 e4 06       	call   0x187544050
   1806f48f3:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   1806f48f7:	48 8b 45 40          	mov    rax,QWORD PTR [rbp+0x40]
   1806f48fb:	48 8d b0 58 07 00 00 	lea    rsi,[rax+0x758]
   1806f4902:	4c 39 f6             	cmp    rsi,r14
   1806f4905:	74 5b                	je     0x1806f4962
   1806f4907:	48 8b 7d 30          	mov    rdi,QWORD PTR [rbp+0x30]
   1806f490b:	48 83 7d 38 10       	cmp    QWORD PTR [rbp+0x38],0x10
   1806f4910:	72 34                	jb     0x1806f4946
   1806f4912:	4c 8b 4d 20          	mov    r9,QWORD PTR [rbp+0x20]
   1806f4916:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1806f491d:	48 39 cf             	cmp    rdi,rcx
   1806f4920:	77 34                	ja     0x1806f4956
   1806f4922:	48 83 f9 10          	cmp    rcx,0x10
   1806f4926:	72 03                	jb     0x1806f492b
   1806f4928:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1806f492b:	48 89 b8 68 07 00 00 	mov    QWORD PTR [rax+0x768],rdi
   1806f4932:	48 89 f1             	mov    rcx,rsi
   1806f4935:	4c 89 ca             	mov    rdx,r9
   1806f4938:	49 89 f8             	mov    r8,rdi
   1806f493b:	e8 10 f7 e4 06       	call   0x187544050
   1806f4940:	c6 04 3e 00          	mov    BYTE PTR [rsi+rdi*1],0x0
   1806f4944:	eb 1c                	jmp    0x1806f4962
   1806f4946:	4c 8d 4d 20          	lea    r9,[rbp+0x20]
   1806f494a:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1806f4951:	48 39 cf             	cmp    rdi,rcx
   1806f4954:	76 cc                	jbe    0x1806f4922
   1806f4956:	48 89 f1             	mov    rcx,rsi
   1806f4959:	48 89 fa             	mov    rdx,rdi
   1806f495c:	e8 ef 97 94 ff       	call   0x18003e150
   1806f4961:	90                   	nop
   1806f4962:	48 8b 45 40          	mov    rax,QWORD PTR [rbp+0x40]
   1806f4966:	c7 80 9c 00 00 00 01 	mov    DWORD PTR [rax+0x9c],0x1
   1806f496d:	00 00 00 
   1806f4970:	48 89 e9             	mov    rcx,rbp
   1806f4973:	e8 a8 28 95 ff       	call   0x180047220
   1806f4978:	90                   	nop
   1806f4979:	48 8b 4d 00          	mov    rcx,QWORD PTR [rbp+0x0]
   1806f497d:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1806f4981:	e8 ba 7d c7 ff       	call   0x18036c740
   1806f4986:	90                   	nop
   1806f4987:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1806f498b:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   1806f498f:	e8 fc 03 00 00       	call   0x1806f4d90
   1806f4994:	90                   	nop
   1806f4995:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   1806f4999:	0f 57 c0             	xorps  xmm0,xmm0
   1806f499c:	0f 29 45 10          	movaps XMMWORD PTR [rbp+0x10],xmm0
   1806f49a0:	48 8b 45 48          	mov    rax,QWORD PTR [rbp+0x48]
   1806f49a4:	48 85 c0             	test   rax,rax
   1806f49a7:	74 0a                	je     0x1806f49b3
   1806f49a9:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1806f49ad:	48 8b 45 48          	mov    rax,QWORD PTR [rbp+0x48]
   1806f49b1:	eb 02                	jmp    0x1806f49b5
   1806f49b3:	31 c0                	xor    eax,eax
   1806f49b5:	48 8b 55 40          	mov    rdx,QWORD PTR [rbp+0x40]
   1806f49b9:	48 89 55 10          	mov    QWORD PTR [rbp+0x10],rdx
   1806f49bd:	48 89 45 18          	mov    QWORD PTR [rbp+0x18],rax
   1806f49c1:	48 8d 55 a8          	lea    rdx,[rbp-0x58]
   1806f49c5:	4c 8d 45 10          	lea    r8,[rbp+0x10]
   1806f49c9:	e8 52 ad 09 01       	call   0x18178f720
   1806f49ce:	90                   	nop
   1806f49cf:	48 8b 75 d8          	mov    rsi,QWORD PTR [rbp-0x28]
   1806f49d3:	48 85 f6             	test   rsi,rsi
   1806f49d6:	74 1d                	je     0x1806f49f5
   1806f49d8:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1806f49dc:	75 17                	jne    0x1806f49f5
   1806f49de:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f49e1:	48 89 f1             	mov    rcx,rsi
   1806f49e4:	ff 10                	call   QWORD PTR [rax]
   1806f49e6:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1806f49ea:	75 09                	jne    0x1806f49f5
   1806f49ec:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f49ef:	48 89 f1             	mov    rcx,rsi
   1806f49f2:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806f49f5:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1806f49f9:	48 83 f8 10          	cmp    rax,0x10
   1806f49fd:	72 35                	jb     0x1806f4a34
   1806f49ff:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1806f4a03:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1806f4a07:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806f4a0e:	72 1f                	jb     0x1806f4a2f
   1806f4a10:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1806f4a14:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806f4a18:	4c 29 c1             	sub    rcx,r8
   1806f4a1b:	48 83 f9 20          	cmp    rcx,0x20
   1806f4a1f:	0f 83 fc 00 00 00    	jae    0x1806f4b21
   1806f4a25:	48 83 c0 28          	add    rax,0x28
   1806f4a29:	48 89 c2             	mov    rdx,rax
   1806f4a2c:	4c 89 c1             	mov    rcx,r8
   1806f4a2f:	e8 ac 6e db 06       	call   0x1874ab8e0
   1806f4a34:	48 8b 75 e8          	mov    rsi,QWORD PTR [rbp-0x18]
   1806f4a38:	48 85 f6             	test   rsi,rsi
   1806f4a3b:	74 1d                	je     0x1806f4a5a
   1806f4a3d:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1806f4a41:	75 17                	jne    0x1806f4a5a
   1806f4a43:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4a46:	48 89 f1             	mov    rcx,rsi
   1806f4a49:	ff 10                	call   QWORD PTR [rax]
   1806f4a4b:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1806f4a4f:	75 09                	jne    0x1806f4a5a
   1806f4a51:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4a54:	48 89 f1             	mov    rcx,rsi
   1806f4a57:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806f4a5a:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
   1806f4a5e:	48 85 f6             	test   rsi,rsi
   1806f4a61:	74 1d                	je     0x1806f4a80
   1806f4a63:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1806f4a67:	75 17                	jne    0x1806f4a80
   1806f4a69:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4a6c:	48 89 f1             	mov    rcx,rsi
   1806f4a6f:	ff 10                	call   QWORD PTR [rax]
   1806f4a71:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1806f4a75:	75 09                	jne    0x1806f4a80
   1806f4a77:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4a7a:	48 89 f1             	mov    rcx,rsi
   1806f4a7d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806f4a80:	48 8b 75 08          	mov    rsi,QWORD PTR [rbp+0x8]
   1806f4a84:	48 85 f6             	test   rsi,rsi
   1806f4a87:	74 1d                	je     0x1806f4aa6
   1806f4a89:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1806f4a8d:	75 17                	jne    0x1806f4aa6
   1806f4a8f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4a92:	48 89 f1             	mov    rcx,rsi
   1806f4a95:	ff 10                	call   QWORD PTR [rax]
   1806f4a97:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1806f4a9b:	75 09                	jne    0x1806f4aa6
   1806f4a9d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4aa0:	48 89 f1             	mov    rcx,rsi
   1806f4aa3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806f4aa6:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   1806f4aaa:	48 83 f8 10          	cmp    rax,0x10
   1806f4aae:	72 31                	jb     0x1806f4ae1
   1806f4ab0:	48 8b 4d 20          	mov    rcx,QWORD PTR [rbp+0x20]
   1806f4ab4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1806f4ab8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806f4abf:	72 1b                	jb     0x1806f4adc
   1806f4ac1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1806f4ac5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806f4ac9:	4c 29 c1             	sub    rcx,r8
   1806f4acc:	48 83 f9 20          	cmp    rcx,0x20
   1806f4ad0:	73 4f                	jae    0x1806f4b21
   1806f4ad2:	48 83 c0 28          	add    rax,0x28
   1806f4ad6:	48 89 c2             	mov    rdx,rax
   1806f4ad9:	4c 89 c1             	mov    rcx,r8
   1806f4adc:	e8 ff 6d db 06       	call   0x1874ab8e0
   1806f4ae1:	48 8b 75 48          	mov    rsi,QWORD PTR [rbp+0x48]
   1806f4ae5:	48 85 f6             	test   rsi,rsi
   1806f4ae8:	74 1d                	je     0x1806f4b07
   1806f4aea:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1806f4aee:	75 17                	jne    0x1806f4b07
   1806f4af0:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4af3:	48 89 f1             	mov    rcx,rsi
   1806f4af6:	ff 10                	call   QWORD PTR [rax]
   1806f4af8:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1806f4afc:	75 09                	jne    0x1806f4b07
   1806f4afe:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1806f4b01:	48 89 f1             	mov    rcx,rsi
   1806f4b04:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806f4b07:	0f 28 75 60          	movaps xmm6,XMMWORD PTR [rbp+0x60]
   1806f4b0b:	48 81 c4 f8 00 00 00 	add    rsp,0xf8
   1806f4b12:	5b                   	pop    rbx
   1806f4b13:	5f                   	pop    rdi
   1806f4b14:	5e                   	pop    rsi
   1806f4b15:	41 5e                	pop    r14
   1806f4b17:	41 5f                	pop    r15
   1806f4b19:	5d                   	pop    rbp
   1806f4b1a:	c3                   	ret
   1806f4b1b:	e8 70 40 91 ff       	call   0x180008b90
   1806f4b20:	90                   	nop
   1806f4b21:	e8 66 88 e1 06       	call   0x18750d38c
   1806f4b26:	cc                   	int3
