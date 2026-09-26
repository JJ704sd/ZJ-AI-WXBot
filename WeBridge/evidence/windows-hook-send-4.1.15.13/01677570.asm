
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181677570 <.text+0x1676570>:
   181677570:	55                   	push   rbp
   181677571:	56                   	push   rsi
   181677572:	57                   	push   rdi
   181677573:	48 81 ec f0 01 00 00 	sub    rsp,0x1f0
   18167757a:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   181677581:	00 
   181677582:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   181677589:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0xfffffffffffffffe
   181677590:	fe ff ff ff 
   181677594:	48 89 ce             	mov    rsi,rcx
   181677597:	48 83 3d b9 7f 2b 0a 	cmp    QWORD PTR [rip+0xa2b7fb9],0x0        # 0x18b92f558
   18167759e:	00 
   18167759f:	0f 84 76 02 00 00    	je     0x18167781b
   1816775a5:	48 83 3d b3 7f 2b 0a 	cmp    QWORD PTR [rip+0xa2b7fb3],0x0        # 0x18b92f560
   1816775ac:	00 
   1816775ad:	0f 84 39 03 00 00    	je     0x1816778ec
   1816775b3:	48 83 3d ad 7f 2b 0a 	cmp    QWORD PTR [rip+0xa2b7fad],0x0        # 0x18b92f568
   1816775ba:	00 
   1816775bb:	0f 84 5c 03 00 00    	je     0x18167791d
   1816775c1:	0f 28 05 e8 e5 6c 07 	movaps xmm0,XMMWORD PTR [rip+0x76ce5e8]        # 0x188d45bb0
   1816775c8:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   1816775cc:	0f 29 45 d0          	movaps XMMWORD PTR [rbp-0x30],xmm0
   1816775d0:	48 8d 7d d0          	lea    rdi,[rbp-0x30]
   1816775d4:	48 89 f9             	mov    rcx,rdi
   1816775d7:	31 d2                	xor    edx,edx
   1816775d9:	e8 d2 77 a1 fe       	call   0x18008edb0
   1816775de:	48 8d 05 0b 31 86 07 	lea    rax,[rip+0x786310b]        # 0x188eda6f0
   1816775e5:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
   1816775e9:	48 c7 45 c8 07 00 00 	mov    QWORD PTR [rbp-0x38],0x7
   1816775f0:	00 
   1816775f1:	48 8d 55 20          	lea    rdx,[rbp+0x20]
   1816775f5:	4c 8d 45 c0          	lea    r8,[rbp-0x40]
   1816775f9:	48 89 f9             	mov    rcx,rdi
   1816775fc:	e8 8f 58 a2 fe       	call   0x18009ce90
   181677601:	90                   	nop
   181677602:	48 8d 4d d0          	lea    rcx,[rbp-0x30]
   181677606:	48 8d 7d 20          	lea    rdi,[rbp+0x20]
   18167760a:	48 89 fa             	mov    rdx,rdi
   18167760d:	e8 2e 40 a2 fe       	call   0x18009b640
   181677612:	48 89 f9             	mov    rcx,rdi
   181677615:	e8 46 04 99 fe       	call   0x180007a60
   18167761a:	90                   	nop
   18167761b:	e8 f0 e6 9c fe       	call   0x180045d10
   181677620:	90                   	nop
   181677621:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   181677624:	48 89 c1             	mov    rcx,rax
   181677627:	ff 52 08             	call   QWORD PTR [rdx+0x8]
   18167762a:	90                   	nop
   18167762b:	8b b8 80 00 00 00    	mov    edi,DWORD PTR [rax+0x80]
   181677631:	48 c7 45 08 00 00 00 	mov    QWORD PTR [rbp+0x8],0x0
   181677638:	00 
   181677639:	48 c7 45 10 0c 00 00 	mov    QWORD PTR [rbp+0x10],0xc
   181677640:	00 
   181677641:	48 c7 45 18 0f 00 00 	mov    QWORD PTR [rbp+0x18],0xf
   181677648:	00 
   181677649:	48 b8 55 6e 69 57 65 	movabs rax,0x6168436557696e55
   181677650:	43 68 61 
   181677653:	48 89 45 00          	mov    QWORD PTR [rbp+0x0],rax
   181677657:	c7 45 08 74 57 69 6e 	mov    DWORD PTR [rbp+0x8],0x6e695774
   18167765e:	48 8d 4d d0          	lea    rcx,[rbp-0x30]
   181677662:	48 8d 55 20          	lea    rdx,[rbp+0x20]
   181677666:	e8 05 84 a2 fe       	call   0x18009fa70
   18167766b:	90                   	nop
   18167766c:	48 89 e9             	mov    rcx,rbp
   18167766f:	4c 8d 45 20          	lea    r8,[rbp+0x20]
   181677673:	89 fa                	mov    edx,edi
   181677675:	e8 b6 76 46 ff       	call   0x180aded30
   18167767a:	90                   	nop
   18167767b:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   18167767f:	48 83 f8 10          	cmp    rax,0x10
   181677683:	72 36                	jb     0x1816776bb
   181677685:	48 8b 4d 20          	mov    rcx,QWORD PTR [rbp+0x20]
   181677689:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18167768d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181677694:	72 1f                	jb     0x1816776b5
   181677696:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18167769a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18167769e:	4c 29 c1             	sub    rcx,r8
   1816776a1:	48 83 f9 20          	cmp    rcx,0x20
   1816776a5:	0f 83 14 17 00 00    	jae    0x181678dbf
   1816776ab:	48 83 c0 28          	add    rax,0x28
   1816776af:	48 89 c2             	mov    rdx,rax
   1816776b2:	4c 89 c1             	mov    rcx,r8
   1816776b5:	e8 26 42 e3 05       	call   0x1874ab8e0
   1816776ba:	90                   	nop
   1816776bb:	e8 50 e6 9c fe       	call   0x180045d10
   1816776c0:	90                   	nop
   1816776c1:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   1816776c4:	48 89 c1             	mov    rcx,rax
   1816776c7:	ff 52 68             	call   QWORD PTR [rdx+0x68]
   1816776ca:	90                   	nop
   1816776cb:	84 c0                	test   al,al
   1816776cd:	74 1f                	je     0x1816776ee
   1816776cf:	e8 3c e6 9c fe       	call   0x180045d10
   1816776d4:	90                   	nop
   1816776d5:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   1816776d8:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1816776dc:	48 89 c1             	mov    rcx,rax
   1816776df:	41 ff 50 18          	call   QWORD PTR [r8+0x18]
   1816776e3:	90                   	nop
   1816776e4:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1816776e8:	e8 d3 a3 46 ff       	call   0x180ae1ac0
   1816776ed:	90                   	nop
   1816776ee:	48 83 3d 5a 7e 2b 0a 	cmp    QWORD PTR [rip+0xa2b7e5a],0x0        # 0x18b92f550
   1816776f5:	00 
   1816776f6:	0f 84 49 02 00 00    	je     0x181677945
   1816776fc:	48 83 3d e4 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7de4],0x0        # 0x18b92f4e8
   181677703:	00 
   181677704:	0f 84 a0 03 00 00    	je     0x181677aaa
   18167770a:	48 83 3d de 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dde],0x0        # 0x18b92f4f0
   181677711:	00 
   181677712:	0f 84 71 05 00 00    	je     0x181677c89
   181677718:	48 83 3d d8 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dd8],0x0        # 0x18b92f4f8
   18167771f:	00 
   181677720:	0f 84 46 07 00 00    	je     0x181677e6c
   181677726:	48 83 3d d2 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dd2],0x0        # 0x18b92f500
   18167772d:	00 
   18167772e:	0f 84 9d 08 00 00    	je     0x181677fd1
   181677734:	48 83 3d cc 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dcc],0x0        # 0x18b92f508
   18167773b:	00 
   18167773c:	0f 84 f4 09 00 00    	je     0x181678136
   181677742:	48 83 3d c6 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dc6],0x0        # 0x18b92f510
   181677749:	00 
   18167774a:	0f 84 4b 0b 00 00    	je     0x18167829b
   181677750:	48 83 3d c0 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dc0],0x0        # 0x18b92f518
   181677757:	00 
   181677758:	0f 84 a2 0c 00 00    	je     0x181678400
   18167775e:	48 83 3d ba 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dba],0x0        # 0x18b92f520
   181677765:	00 
   181677766:	0f 84 f9 0d 00 00    	je     0x181678565
   18167776c:	48 83 3d b4 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7db4],0x0        # 0x18b92f528
   181677773:	00 
   181677774:	0f 84 50 0f 00 00    	je     0x1816786ca
   18167777a:	48 83 3d ae 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7dae],0x0        # 0x18b92f530
   181677781:	00 
   181677782:	0f 84 a7 10 00 00    	je     0x18167882f
   181677788:	48 83 3d b0 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7db0],0x0        # 0x18b92f540
   18167778f:	00 
   181677790:	0f 84 fe 11 00 00    	je     0x181678994
   181677796:	48 83 3d aa 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7daa],0x0        # 0x18b92f548
   18167779d:	00 
   18167779e:	0f 84 55 13 00 00    	je     0x181678af9
   1816777a4:	48 83 3d 8c 7d 2b 0a 	cmp    QWORD PTR [rip+0xa2b7d8c],0x0        # 0x18b92f538
   1816777ab:	00 
   1816777ac:	0f 84 ac 14 00 00    	je     0x181678c5e
   1816777b2:	e8 69 65 47 ff       	call   0x180aedd20
   1816777b7:	90                   	nop
   1816777b8:	48 89 f1             	mov    rcx,rsi
   1816777bb:	e8 50 fa ff ff       	call   0x181677210
   1816777c0:	90                   	nop
   1816777c1:	48 8b 45 18          	mov    rax,QWORD PTR [rbp+0x18]
   1816777c5:	48 83 f8 10          	cmp    rax,0x10
   1816777c9:	72 35                	jb     0x181677800
   1816777cb:	48 8b 4d 00          	mov    rcx,QWORD PTR [rbp+0x0]
   1816777cf:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1816777d3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1816777da:	72 1f                	jb     0x1816777fb
   1816777dc:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1816777e0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1816777e4:	4c 29 c1             	sub    rcx,r8
   1816777e7:	48 83 f9 20          	cmp    rcx,0x20
   1816777eb:	0f 83 ce 15 00 00    	jae    0x181678dbf
   1816777f1:	48 83 c0 28          	add    rax,0x28
   1816777f5:	48 89 c2             	mov    rdx,rax
   1816777f8:	4c 89 c1             	mov    rcx,r8
   1816777fb:	e8 e0 40 e3 05       	call   0x1874ab8e0
   181677800:	48 8d 4d d0          	lea    rcx,[rbp-0x30]
   181677804:	e8 57 02 99 fe       	call   0x180007a60
   181677809:	0f 28 b5 60 01 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x160]
   181677810:	48 81 c4 f0 01 00 00 	add    rsp,0x1f0
   181677817:	5f                   	pop    rdi
   181677818:	5e                   	pop    rsi
   181677819:	5d                   	pop    rbp
   18167781a:	c3                   	ret
   18167781b:	b9 78 00 00 00       	mov    ecx,0x78
   181677820:	e8 77 40 e3 05       	call   0x1874ab89c
   181677825:	0f 57 f6             	xorps  xmm6,xmm6
   181677828:	0f 29 30             	movaps XMMWORD PTR [rax],xmm6
   18167782b:	0f 29 70 50          	movaps XMMWORD PTR [rax+0x50],xmm6
   18167782f:	0f 29 70 60          	movaps XMMWORD PTR [rax+0x60],xmm6
   181677833:	0f 29 70 10          	movaps XMMWORD PTR [rax+0x10],xmm6
   181677837:	0f 29 70 20          	movaps XMMWORD PTR [rax+0x20],xmm6
   18167783b:	0f 29 70 30          	movaps XMMWORD PTR [rax+0x30],xmm6
   18167783f:	0f 29 70 40          	movaps XMMWORD PTR [rax+0x40],xmm6
   181677843:	48 c7 40 70 00 00 00 	mov    QWORD PTR [rax+0x70],0x0
   18167784a:	00 
   18167784b:	48 8d 0d 86 fc a3 07 	lea    rcx,[rip+0x7a3fc86]        # 0x1890b74d8
   181677852:	48 89 08             	mov    QWORD PTR [rax],rcx
   181677855:	c7 40 50 ff ff ff ff 	mov    DWORD PTR [rax+0x50],0xffffffff
   18167785c:	c7 40 08 02 00 00 00 	mov    DWORD PTR [rax+0x8],0x2
   181677863:	0f 11 70 54          	movups XMMWORD PTR [rax+0x54],xmm6
   181677867:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   18167786e:	c7 40 64 00 00 00 00 	mov    DWORD PTR [rax+0x64],0x0
   181677875:	b9 48 00 00 00       	mov    ecx,0x48
   18167787a:	e8 1d 40 e3 05       	call   0x1874ab89c
   18167787f:	90                   	nop
   181677880:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181677887:	48 89 ca             	mov    rdx,rcx
   18167788a:	48 83 c2 58          	add    rdx,0x58
   18167788e:	48 89 55 f8          	mov    QWORD PTR [rbp-0x8],rdx
   181677892:	48 89 00             	mov    QWORD PTR [rax],rax
   181677895:	48 89 40 08          	mov    QWORD PTR [rax+0x8],rax
   181677899:	48 89 40 10          	mov    QWORD PTR [rax+0x10],rax
   18167789d:	66 c7 40 18 01 01    	mov    WORD PTR [rax+0x18],0x101
   1816778a3:	48 89 41 58          	mov    QWORD PTR [rcx+0x58],rax
   1816778a7:	0f 11 71 68          	movups XMMWORD PTR [rcx+0x68],xmm6
   1816778ab:	b9 50 00 00 00       	mov    ecx,0x50
   1816778b0:	e8 e7 3f e3 05       	call   0x1874ab89c
   1816778b5:	90                   	nop
   1816778b6:	48 89 00             	mov    QWORD PTR [rax],rax
   1816778b9:	48 89 40 08          	mov    QWORD PTR [rax+0x8],rax
   1816778bd:	48 89 40 10          	mov    QWORD PTR [rax+0x10],rax
   1816778c1:	66 c7 40 18 01 01    	mov    WORD PTR [rax+0x18],0x101
   1816778c7:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   1816778ce:	48 89 41 68          	mov    QWORD PTR [rcx+0x68],rax
   1816778d2:	48 89 0d 7f 7c 2b 0a 	mov    QWORD PTR [rip+0xa2b7c7f],rcx        # 0x18b92f558
   1816778d9:	e8 02 fa 46 ff       	call   0x180ae72e0
   1816778de:	48 83 3d 7a 7c 2b 0a 	cmp    QWORD PTR [rip+0xa2b7c7a],0x0        # 0x18b92f560
   1816778e5:	00 
   1816778e6:	0f 85 c7 fc ff ff    	jne    0x1816775b3
   1816778ec:	b9 08 00 00 00       	mov    ecx,0x8
   1816778f1:	e8 a6 3f e3 05       	call   0x1874ab89c
   1816778f6:	48 8d 0d ab fc a3 07 	lea    rcx,[rip+0x7a3fcab]        # 0x1890b75a8
   1816778fd:	48 89 08             	mov    QWORD PTR [rax],rcx
   181677900:	48 89 05 59 7c 2b 0a 	mov    QWORD PTR [rip+0xa2b7c59],rax        # 0x18b92f560
   181677907:	48 89 c1             	mov    rcx,rax
   18167790a:	e8 c1 f9 46 ff       	call   0x180ae72d0
   18167790f:	48 83 3d 51 7c 2b 0a 	cmp    QWORD PTR [rip+0xa2b7c51],0x0        # 0x18b92f568
   181677916:	00 
   181677917:	0f 85 a4 fc ff ff    	jne    0x1816775c1
   18167791d:	b9 08 00 00 00       	mov    ecx,0x8
   181677922:	e8 75 3f e3 05       	call   0x1874ab89c
   181677927:	48 8d 0d 3a fd a3 07 	lea    rcx,[rip+0x7a3fd3a]        # 0x1890b7668
   18167792e:	48 89 08             	mov    QWORD PTR [rax],rcx
   181677931:	48 89 05 30 7c 2b 0a 	mov    QWORD PTR [rip+0xa2b7c30],rax        # 0x18b92f568
   181677938:	48 89 c1             	mov    rcx,rax
   18167793b:	e8 b0 f9 46 ff       	call   0x180ae72f0
   181677940:	e9 7c fc ff ff       	jmp    0x1816775c1
   181677945:	b9 98 02 00 00       	mov    ecx,0x298
   18167794a:	e8 4d 3f e3 05       	call   0x1874ab89c
   18167794f:	90                   	nop
   181677950:	48 89 c7             	mov    rdi,rax
   181677953:	41 b8 98 02 00 00    	mov    r8d,0x298
   181677959:	48 89 c1             	mov    rcx,rax
   18167795c:	31 d2                	xor    edx,edx
   18167795e:	e8 8d cd ec 05       	call   0x1875446f0
   181677963:	90                   	nop
   181677964:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   18167796b:	48 89 f9             	mov    rcx,rdi
   18167796e:	e8 6d b7 47 ff       	call   0x180af30e0
   181677973:	90                   	nop
   181677974:	48 8d 05 ad fd a3 07 	lea    rax,[rip+0x7a3fdad]        # 0x1890b7728
   18167797b:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181677982:	48 89 01             	mov    QWORD PTR [rcx],rax
   181677985:	48 89 0d c4 7b 2b 0a 	mov    QWORD PTR [rip+0xa2b7bc4],rcx        # 0x18b92f550
   18167798c:	e8 6f 25 47 ff       	call   0x180ae9f00
   181677991:	90                   	nop
   181677992:	b9 02 00 00 00       	mov    ecx,0x2
   181677997:	e8 44 54 9f fe       	call   0x18006cde0
   18167799c:	85 c0                	test   eax,eax
   18167799e:	0f 84 58 fd ff ff    	je     0x1816776fc
   1816779a4:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   1816779ab:	48 89 f9             	mov    rcx,rdi
   1816779ae:	e8 5d 55 9f fe       	call   0x18006cf10
   1816779b3:	90                   	nop
   1816779b4:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   1816779bb:	10 
   1816779bc:	72 07                	jb     0x1816779c5
   1816779be:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   1816779c5:	48 8d 05 dc 0f a4 07 	lea    rax,[rip+0x7a40fdc]        # 0x1890b89a8
   1816779cc:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1816779d1:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1816779d8:	00 00 
   1816779da:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1816779df:	c7 44 24 28 68 01 00 	mov    DWORD PTR [rsp+0x28],0x168
   1816779e6:	00 
   1816779e7:	4c 8d 0d aa 0e a4 07 	lea    r9,[rip+0x7a40eaa]        # 0x1890b8898
   1816779ee:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816779f2:	ba 02 00 00 00       	mov    edx,0x2
   1816779f7:	49 89 f8             	mov    r8,rdi
   1816779fa:	e8 71 58 9f fe       	call   0x18006d270
   1816779ff:	90                   	nop
   181677a00:	0f 57 c0             	xorps  xmm0,xmm0
   181677a03:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181677a0a:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181677a11:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181677a18:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181677a1f:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181677a26:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181677a2d:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181677a34:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181677a3b:	48 8d 15 5e 13 a4 07 	lea    rdx,[rip+0x7a4135e]        # 0x1890b8da0
   181677a42:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677a46:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181677a4d:	e8 be 5d 9f fe       	call   0x18006d810
   181677a52:	90                   	nop
   181677a53:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677a57:	e8 14 59 9f fe       	call   0x18006d370
   181677a5c:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181677a63:	48 83 f8 10          	cmp    rax,0x10
   181677a67:	0f 82 8f fc ff ff    	jb     0x1816776fc
   181677a6d:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181677a74:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181677a78:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181677a7f:	72 1f                	jb     0x181677aa0
   181677a81:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181677a85:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181677a89:	4c 29 c1             	sub    rcx,r8
   181677a8c:	48 83 f9 20          	cmp    rcx,0x20
   181677a90:	0f 83 29 13 00 00    	jae    0x181678dbf
   181677a96:	48 83 c0 28          	add    rax,0x28
   181677a9a:	48 89 c2             	mov    rdx,rax
   181677a9d:	4c 89 c1             	mov    rcx,r8
   181677aa0:	e8 3b 3e e3 05       	call   0x1874ab8e0
   181677aa5:	e9 52 fc ff ff       	jmp    0x1816776fc
   181677aaa:	b9 98 02 00 00       	mov    ecx,0x298
   181677aaf:	e8 e8 3d e3 05       	call   0x1874ab89c
   181677ab4:	90                   	nop
   181677ab5:	48 89 c7             	mov    rdi,rax
   181677ab8:	41 b8 98 02 00 00    	mov    r8d,0x298
   181677abe:	48 89 c1             	mov    rcx,rax
   181677ac1:	31 d2                	xor    edx,edx
   181677ac3:	e8 28 cc ec 05       	call   0x1875446f0
   181677ac8:	90                   	nop
   181677ac9:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181677ad0:	48 89 f9             	mov    rcx,rdi
   181677ad3:	e8 08 b6 47 ff       	call   0x180af30e0
   181677ad8:	90                   	nop
   181677ad9:	48 8d 05 48 fd a3 07 	lea    rax,[rip+0x7a3fd48]        # 0x1890b7828
   181677ae0:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181677ae7:	48 89 01             	mov    QWORD PTR [rcx],rax
   181677aea:	48 89 0d f7 79 2b 0a 	mov    QWORD PTR [rip+0xa2b79f7],rcx        # 0x18b92f4e8
   181677af1:	48 c7 45 28 00 00 00 	mov    QWORD PTR [rbp+0x28],0x0
   181677af8:	00 
   181677af9:	48 c7 45 30 07 00 00 	mov    QWORD PTR [rbp+0x30],0x7
   181677b00:	00 
   181677b01:	48 c7 45 38 0f 00 00 	mov    QWORD PTR [rbp+0x38],0xf
   181677b08:	00 
   181677b09:	c7 45 20 58 45 64 69 	mov    DWORD PTR [rbp+0x20],0x69644558
   181677b10:	c7 45 23 69 74 6f 72 	mov    DWORD PTR [rbp+0x23],0x726f7469
   181677b17:	c6 45 27 00          	mov    BYTE PTR [rbp+0x27],0x0
   181677b1b:	48 8d 55 20          	lea    rdx,[rbp+0x20]
   181677b1f:	e8 3c 17 4b ff       	call   0x180b29260
   181677b24:	90                   	nop
   181677b25:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   181677b29:	48 83 f8 10          	cmp    rax,0x10
   181677b2d:	72 35                	jb     0x181677b64
   181677b2f:	48 8b 4d 20          	mov    rcx,QWORD PTR [rbp+0x20]
   181677b33:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181677b37:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181677b3e:	72 1f                	jb     0x181677b5f
   181677b40:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181677b44:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181677b48:	4c 29 c1             	sub    rcx,r8
   181677b4b:	48 83 f9 20          	cmp    rcx,0x20
   181677b4f:	0f 83 6a 12 00 00    	jae    0x181678dbf
   181677b55:	48 83 c0 28          	add    rax,0x28
   181677b59:	48 89 c2             	mov    rdx,rax
   181677b5c:	4c 89 c1             	mov    rcx,r8
   181677b5f:	e8 7c 3d e3 05       	call   0x1874ab8e0
   181677b64:	48 8b 0d 7d 79 2b 0a 	mov    rcx,QWORD PTR [rip+0xa2b797d]        # 0x18b92f4e8
   181677b6b:	e8 90 23 47 ff       	call   0x180ae9f00
   181677b70:	90                   	nop
   181677b71:	b9 02 00 00 00       	mov    ecx,0x2
   181677b76:	e8 65 52 9f fe       	call   0x18006cde0
   181677b7b:	85 c0                	test   eax,eax
   181677b7d:	0f 84 87 fb ff ff    	je     0x18167770a
   181677b83:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181677b8a:	48 89 f9             	mov    rcx,rdi
   181677b8d:	e8 7e 53 9f fe       	call   0x18006cf10
   181677b92:	90                   	nop
   181677b93:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181677b9a:	10 
   181677b9b:	72 07                	jb     0x181677ba4
   181677b9d:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181677ba4:	48 8d 05 fd 0d a4 07 	lea    rax,[rip+0x7a40dfd]        # 0x1890b89a8
   181677bab:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181677bb0:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181677bb7:	00 00 
   181677bb9:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181677bbe:	c7 44 24 28 6f 01 00 	mov    DWORD PTR [rsp+0x28],0x16f
   181677bc5:	00 
   181677bc6:	4c 8d 0d cb 0c a4 07 	lea    r9,[rip+0x7a40ccb]        # 0x1890b8898
   181677bcd:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677bd1:	ba 02 00 00 00       	mov    edx,0x2
   181677bd6:	49 89 f8             	mov    r8,rdi
   181677bd9:	e8 92 56 9f fe       	call   0x18006d270
   181677bde:	90                   	nop
   181677bdf:	0f 57 c0             	xorps  xmm0,xmm0
   181677be2:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181677be9:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181677bf0:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181677bf7:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181677bfe:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181677c05:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181677c0c:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181677c13:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181677c1a:	48 8d 15 b7 11 a4 07 	lea    rdx,[rip+0x7a411b7]        # 0x1890b8dd8
   181677c21:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677c25:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181677c2c:	e8 df 5b 9f fe       	call   0x18006d810
   181677c31:	90                   	nop
   181677c32:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677c36:	e8 35 57 9f fe       	call   0x18006d370
   181677c3b:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181677c42:	48 83 f8 10          	cmp    rax,0x10
   181677c46:	0f 82 be fa ff ff    	jb     0x18167770a
   181677c4c:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181677c53:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181677c57:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181677c5e:	72 1f                	jb     0x181677c7f
   181677c60:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181677c64:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181677c68:	4c 29 c1             	sub    rcx,r8
   181677c6b:	48 83 f9 20          	cmp    rcx,0x20
   181677c6f:	0f 83 4a 11 00 00    	jae    0x181678dbf
   181677c75:	48 83 c0 28          	add    rax,0x28
   181677c79:	48 89 c2             	mov    rdx,rax
   181677c7c:	4c 89 c1             	mov    rcx,r8
   181677c7f:	e8 5c 3c e3 05       	call   0x1874ab8e0
   181677c84:	e9 81 fa ff ff       	jmp    0x18167770a
   181677c89:	b9 98 02 00 00       	mov    ecx,0x298
   181677c8e:	e8 09 3c e3 05       	call   0x1874ab89c
   181677c93:	90                   	nop
   181677c94:	48 89 c7             	mov    rdi,rax
   181677c97:	41 b8 98 02 00 00    	mov    r8d,0x298
   181677c9d:	48 89 c1             	mov    rcx,rax
   181677ca0:	31 d2                	xor    edx,edx
   181677ca2:	e8 49 ca ec 05       	call   0x1875446f0
   181677ca7:	90                   	nop
   181677ca8:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181677caf:	48 89 f9             	mov    rcx,rdi
   181677cb2:	e8 29 b4 47 ff       	call   0x180af30e0
   181677cb7:	90                   	nop
   181677cb8:	48 8d 05 69 fc a3 07 	lea    rax,[rip+0x7a3fc69]        # 0x1890b7928
   181677cbf:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181677cc6:	48 89 01             	mov    QWORD PTR [rcx],rax
   181677cc9:	48 89 0d 20 78 2b 0a 	mov    QWORD PTR [rip+0xa2b7820],rcx        # 0x18b92f4f0
   181677cd0:	e8 2b 22 47 ff       	call   0x180ae9f00
   181677cd5:	90                   	nop
   181677cd6:	48 8b 0d 13 78 2b 0a 	mov    rcx,QWORD PTR [rip+0xa2b7813]        # 0x18b92f4f0
   181677cdd:	48 c7 45 28 00 00 00 	mov    QWORD PTR [rbp+0x28],0x0
   181677ce4:	00 
   181677ce5:	48 c7 45 30 0a 00 00 	mov    QWORD PTR [rbp+0x30],0xa
   181677cec:	00 
   181677ced:	48 c7 45 38 0f 00 00 	mov    QWORD PTR [rbp+0x38],0xf
   181677cf4:	00 
   181677cf5:	48 b8 52 61 64 69 75 	movabs rax,0x4d576d7569646152
   181677cfc:	6d 57 4d 
   181677cff:	48 89 45 20          	mov    QWORD PTR [rbp+0x20],rax
   181677d03:	66 c7 45 28 50 46    	mov    WORD PTR [rbp+0x28],0x4650
   181677d09:	4c 8d 45 20          	lea    r8,[rbp+0x20]
   181677d0d:	b2 01                	mov    dl,0x1
   181677d0f:	e8 9c 16 4b ff       	call   0x180b293b0
   181677d14:	90                   	nop
   181677d15:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   181677d19:	48 83 f8 10          	cmp    rax,0x10
   181677d1d:	72 35                	jb     0x181677d54
   181677d1f:	48 8b 4d 20          	mov    rcx,QWORD PTR [rbp+0x20]
   181677d23:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181677d27:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181677d2e:	72 1f                	jb     0x181677d4f
   181677d30:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181677d34:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181677d38:	4c 29 c1             	sub    rcx,r8
   181677d3b:	48 83 f9 20          	cmp    rcx,0x20
   181677d3f:	0f 83 7a 10 00 00    	jae    0x181678dbf
   181677d45:	48 83 c0 28          	add    rax,0x28
   181677d49:	48 89 c2             	mov    rdx,rax
   181677d4c:	4c 89 c1             	mov    rcx,r8
   181677d4f:	e8 8c 3b e3 05       	call   0x1874ab8e0
   181677d54:	b9 02 00 00 00       	mov    ecx,0x2
   181677d59:	e8 82 50 9f fe       	call   0x18006cde0
   181677d5e:	85 c0                	test   eax,eax
   181677d60:	0f 84 b2 f9 ff ff    	je     0x181677718
   181677d66:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181677d6d:	48 89 f9             	mov    rcx,rdi
   181677d70:	e8 9b 51 9f fe       	call   0x18006cf10
   181677d75:	90                   	nop
   181677d76:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181677d7d:	10 
   181677d7e:	72 07                	jb     0x181677d87
   181677d80:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181677d87:	48 8d 05 1a 0c a4 07 	lea    rax,[rip+0x7a40c1a]        # 0x1890b89a8
   181677d8e:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181677d93:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181677d9a:	00 00 
   181677d9c:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181677da1:	c7 44 24 28 76 01 00 	mov    DWORD PTR [rsp+0x28],0x176
   181677da8:	00 
   181677da9:	4c 8d 0d e8 0a a4 07 	lea    r9,[rip+0x7a40ae8]        # 0x1890b8898
   181677db0:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677db4:	ba 02 00 00 00       	mov    edx,0x2
   181677db9:	49 89 f8             	mov    r8,rdi
   181677dbc:	e8 af 54 9f fe       	call   0x18006d270
   181677dc1:	90                   	nop
   181677dc2:	0f 57 c0             	xorps  xmm0,xmm0
   181677dc5:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181677dcc:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181677dd3:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181677dda:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181677de1:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181677de8:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181677def:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181677df6:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181677dfd:	48 8d 15 5c 0a a4 07 	lea    rdx,[rip+0x7a40a5c]        # 0x1890b8860
   181677e04:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677e08:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181677e0f:	e8 fc 59 9f fe       	call   0x18006d810
   181677e14:	90                   	nop
   181677e15:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677e19:	e8 52 55 9f fe       	call   0x18006d370
   181677e1e:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181677e25:	48 83 f8 10          	cmp    rax,0x10
   181677e29:	0f 82 e9 f8 ff ff    	jb     0x181677718
   181677e2f:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181677e36:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181677e3a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181677e41:	72 1f                	jb     0x181677e62
   181677e43:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181677e47:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181677e4b:	4c 29 c1             	sub    rcx,r8
   181677e4e:	48 83 f9 20          	cmp    rcx,0x20
   181677e52:	0f 83 67 0f 00 00    	jae    0x181678dbf
   181677e58:	48 83 c0 28          	add    rax,0x28
   181677e5c:	48 89 c2             	mov    rdx,rax
   181677e5f:	4c 89 c1             	mov    rcx,r8
   181677e62:	e8 79 3a e3 05       	call   0x1874ab8e0
   181677e67:	e9 ac f8 ff ff       	jmp    0x181677718
   181677e6c:	b9 98 02 00 00       	mov    ecx,0x298
   181677e71:	e8 26 3a e3 05       	call   0x1874ab89c
   181677e76:	90                   	nop
   181677e77:	48 89 c7             	mov    rdi,rax
   181677e7a:	41 b8 98 02 00 00    	mov    r8d,0x298
   181677e80:	48 89 c1             	mov    rcx,rax
   181677e83:	31 d2                	xor    edx,edx
   181677e85:	e8 66 c8 ec 05       	call   0x1875446f0
   181677e8a:	90                   	nop
   181677e8b:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181677e92:	48 89 f9             	mov    rcx,rdi
   181677e95:	e8 46 b2 47 ff       	call   0x180af30e0
   181677e9a:	90                   	nop
   181677e9b:	48 8d 05 86 fb a3 07 	lea    rax,[rip+0x7a3fb86]        # 0x1890b7a28
   181677ea2:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181677ea9:	48 89 01             	mov    QWORD PTR [rcx],rax
   181677eac:	48 89 0d 45 76 2b 0a 	mov    QWORD PTR [rip+0xa2b7645],rcx        # 0x18b92f4f8
   181677eb3:	e8 48 20 47 ff       	call   0x180ae9f00
   181677eb8:	90                   	nop
   181677eb9:	b9 02 00 00 00       	mov    ecx,0x2
   181677ebe:	e8 1d 4f 9f fe       	call   0x18006cde0
   181677ec3:	85 c0                	test   eax,eax
   181677ec5:	0f 84 5b f8 ff ff    	je     0x181677726
   181677ecb:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181677ed2:	48 89 f9             	mov    rcx,rdi
   181677ed5:	e8 36 50 9f fe       	call   0x18006cf10
   181677eda:	90                   	nop
   181677edb:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181677ee2:	10 
   181677ee3:	72 07                	jb     0x181677eec
   181677ee5:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181677eec:	48 8d 05 b5 0a a4 07 	lea    rax,[rip+0x7a40ab5]        # 0x1890b89a8
   181677ef3:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181677ef8:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181677eff:	00 00 
   181677f01:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181677f06:	c7 44 24 28 7c 01 00 	mov    DWORD PTR [rsp+0x28],0x17c
   181677f0d:	00 
   181677f0e:	4c 8d 0d 83 09 a4 07 	lea    r9,[rip+0x7a40983]        # 0x1890b8898
   181677f15:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677f19:	ba 02 00 00 00       	mov    edx,0x2
   181677f1e:	49 89 f8             	mov    r8,rdi
   181677f21:	e8 4a 53 9f fe       	call   0x18006d270
   181677f26:	90                   	nop
   181677f27:	0f 57 c0             	xorps  xmm0,xmm0
   181677f2a:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181677f31:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181677f38:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181677f3f:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181677f46:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181677f4d:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181677f54:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181677f5b:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181677f62:	48 8d 15 d7 09 a4 07 	lea    rdx,[rip+0x7a409d7]        # 0x1890b8940
   181677f69:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677f6d:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181677f74:	e8 97 58 9f fe       	call   0x18006d810
   181677f79:	90                   	nop
   181677f7a:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181677f7e:	e8 ed 53 9f fe       	call   0x18006d370
   181677f83:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181677f8a:	48 83 f8 10          	cmp    rax,0x10
   181677f8e:	0f 82 92 f7 ff ff    	jb     0x181677726
   181677f94:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181677f9b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181677f9f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181677fa6:	72 1f                	jb     0x181677fc7
   181677fa8:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181677fac:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181677fb0:	4c 29 c1             	sub    rcx,r8
   181677fb3:	48 83 f9 20          	cmp    rcx,0x20
   181677fb7:	0f 83 02 0e 00 00    	jae    0x181678dbf
   181677fbd:	48 83 c0 28          	add    rax,0x28
   181677fc1:	48 89 c2             	mov    rdx,rax
   181677fc4:	4c 89 c1             	mov    rcx,r8
   181677fc7:	e8 14 39 e3 05       	call   0x1874ab8e0
   181677fcc:	e9 55 f7 ff ff       	jmp    0x181677726
   181677fd1:	b9 98 02 00 00       	mov    ecx,0x298
   181677fd6:	e8 c1 38 e3 05       	call   0x1874ab89c
   181677fdb:	90                   	nop
   181677fdc:	48 89 c7             	mov    rdi,rax
   181677fdf:	41 b8 98 02 00 00    	mov    r8d,0x298
   181677fe5:	48 89 c1             	mov    rcx,rax
   181677fe8:	31 d2                	xor    edx,edx
   181677fea:	e8 01 c7 ec 05       	call   0x1875446f0
   181677fef:	90                   	nop
   181677ff0:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181677ff7:	48 89 f9             	mov    rcx,rdi
   181677ffa:	e8 e1 b0 47 ff       	call   0x180af30e0
   181677fff:	90                   	nop
   181678000:	48 8d 05 21 fb a3 07 	lea    rax,[rip+0x7a3fb21]        # 0x1890b7b28
   181678007:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18167800e:	48 89 01             	mov    QWORD PTR [rcx],rax
   181678011:	48 89 0d e8 74 2b 0a 	mov    QWORD PTR [rip+0xa2b74e8],rcx        # 0x18b92f500
   181678018:	e8 e3 1e 47 ff       	call   0x180ae9f00
   18167801d:	90                   	nop
   18167801e:	b9 02 00 00 00       	mov    ecx,0x2
   181678023:	e8 b8 4d 9f fe       	call   0x18006cde0
   181678028:	85 c0                	test   eax,eax
   18167802a:	0f 84 04 f7 ff ff    	je     0x181677734
   181678030:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181678037:	48 89 f9             	mov    rcx,rdi
   18167803a:	e8 d1 4e 9f fe       	call   0x18006cf10
   18167803f:	90                   	nop
   181678040:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181678047:	10 
   181678048:	72 07                	jb     0x181678051
   18167804a:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181678051:	48 8d 05 50 09 a4 07 	lea    rax,[rip+0x7a40950]        # 0x1890b89a8
   181678058:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18167805d:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181678064:	00 00 
   181678066:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18167806b:	c7 44 24 28 82 01 00 	mov    DWORD PTR [rsp+0x28],0x182
   181678072:	00 
   181678073:	4c 8d 0d 1e 08 a4 07 	lea    r9,[rip+0x7a4081e]        # 0x1890b8898
   18167807a:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   18167807e:	ba 02 00 00 00       	mov    edx,0x2
   181678083:	49 89 f8             	mov    r8,rdi
   181678086:	e8 e5 51 9f fe       	call   0x18006d270
   18167808b:	90                   	nop
   18167808c:	0f 57 c0             	xorps  xmm0,xmm0
   18167808f:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181678096:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   18167809d:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1816780a4:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   1816780ab:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1816780b2:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   1816780b9:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   1816780c0:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   1816780c7:	48 8d 15 4a 0d a4 07 	lea    rdx,[rip+0x7a40d4a]        # 0x1890b8e18
   1816780ce:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816780d2:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   1816780d9:	e8 32 57 9f fe       	call   0x18006d810
   1816780de:	90                   	nop
   1816780df:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816780e3:	e8 88 52 9f fe       	call   0x18006d370
   1816780e8:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1816780ef:	48 83 f8 10          	cmp    rax,0x10
   1816780f3:	0f 82 3b f6 ff ff    	jb     0x181677734
   1816780f9:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181678100:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678104:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18167810b:	72 1f                	jb     0x18167812c
   18167810d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181678111:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181678115:	4c 29 c1             	sub    rcx,r8
   181678118:	48 83 f9 20          	cmp    rcx,0x20
   18167811c:	0f 83 9d 0c 00 00    	jae    0x181678dbf
   181678122:	48 83 c0 28          	add    rax,0x28
   181678126:	48 89 c2             	mov    rdx,rax
   181678129:	4c 89 c1             	mov    rcx,r8
   18167812c:	e8 af 37 e3 05       	call   0x1874ab8e0
   181678131:	e9 fe f5 ff ff       	jmp    0x181677734
   181678136:	b9 98 02 00 00       	mov    ecx,0x298
   18167813b:	e8 5c 37 e3 05       	call   0x1874ab89c
   181678140:	90                   	nop
   181678141:	48 89 c7             	mov    rdi,rax
   181678144:	41 b8 98 02 00 00    	mov    r8d,0x298
   18167814a:	48 89 c1             	mov    rcx,rax
   18167814d:	31 d2                	xor    edx,edx
   18167814f:	e8 9c c5 ec 05       	call   0x1875446f0
   181678154:	90                   	nop
   181678155:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   18167815c:	48 89 f9             	mov    rcx,rdi
   18167815f:	e8 7c af 47 ff       	call   0x180af30e0
   181678164:	90                   	nop
   181678165:	48 8d 05 bc fa a3 07 	lea    rax,[rip+0x7a3fabc]        # 0x1890b7c28
   18167816c:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181678173:	48 89 01             	mov    QWORD PTR [rcx],rax
   181678176:	48 89 0d 8b 73 2b 0a 	mov    QWORD PTR [rip+0xa2b738b],rcx        # 0x18b92f508
   18167817d:	e8 7e 1d 47 ff       	call   0x180ae9f00
   181678182:	90                   	nop
   181678183:	b9 02 00 00 00       	mov    ecx,0x2
   181678188:	e8 53 4c 9f fe       	call   0x18006cde0
   18167818d:	85 c0                	test   eax,eax
   18167818f:	0f 84 ad f5 ff ff    	je     0x181677742
   181678195:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   18167819c:	48 89 f9             	mov    rcx,rdi
   18167819f:	e8 6c 4d 9f fe       	call   0x18006cf10
   1816781a4:	90                   	nop
   1816781a5:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   1816781ac:	10 
   1816781ad:	72 07                	jb     0x1816781b6
   1816781af:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   1816781b6:	48 8d 05 eb 07 a4 07 	lea    rax,[rip+0x7a407eb]        # 0x1890b89a8
   1816781bd:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1816781c2:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1816781c9:	00 00 
   1816781cb:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1816781d0:	c7 44 24 28 88 01 00 	mov    DWORD PTR [rsp+0x28],0x188
   1816781d7:	00 
   1816781d8:	4c 8d 0d b9 06 a4 07 	lea    r9,[rip+0x7a406b9]        # 0x1890b8898
   1816781df:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816781e3:	ba 02 00 00 00       	mov    edx,0x2
   1816781e8:	49 89 f8             	mov    r8,rdi
   1816781eb:	e8 80 50 9f fe       	call   0x18006d270
   1816781f0:	90                   	nop
   1816781f1:	0f 57 c0             	xorps  xmm0,xmm0
   1816781f4:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1816781fb:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181678202:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181678209:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181678210:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181678217:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   18167821e:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181678225:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   18167822c:	48 8d 15 ed 05 a4 07 	lea    rdx,[rip+0x7a405ed]        # 0x1890b8820
   181678233:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678237:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   18167823e:	e8 cd 55 9f fe       	call   0x18006d810
   181678243:	90                   	nop
   181678244:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678248:	e8 23 51 9f fe       	call   0x18006d370
   18167824d:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181678254:	48 83 f8 10          	cmp    rax,0x10
   181678258:	0f 82 e4 f4 ff ff    	jb     0x181677742
   18167825e:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181678265:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678269:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181678270:	72 1f                	jb     0x181678291
   181678272:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181678276:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18167827a:	4c 29 c1             	sub    rcx,r8
   18167827d:	48 83 f9 20          	cmp    rcx,0x20
   181678281:	0f 83 38 0b 00 00    	jae    0x181678dbf
   181678287:	48 83 c0 28          	add    rax,0x28
   18167828b:	48 89 c2             	mov    rdx,rax
   18167828e:	4c 89 c1             	mov    rcx,r8
   181678291:	e8 4a 36 e3 05       	call   0x1874ab8e0
   181678296:	e9 a7 f4 ff ff       	jmp    0x181677742
   18167829b:	b9 98 02 00 00       	mov    ecx,0x298
   1816782a0:	e8 f7 35 e3 05       	call   0x1874ab89c
   1816782a5:	90                   	nop
   1816782a6:	48 89 c7             	mov    rdi,rax
   1816782a9:	41 b8 98 02 00 00    	mov    r8d,0x298
   1816782af:	48 89 c1             	mov    rcx,rax
   1816782b2:	31 d2                	xor    edx,edx
   1816782b4:	e8 37 c4 ec 05       	call   0x1875446f0
   1816782b9:	90                   	nop
   1816782ba:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   1816782c1:	48 89 f9             	mov    rcx,rdi
   1816782c4:	e8 17 ae 47 ff       	call   0x180af30e0
   1816782c9:	90                   	nop
   1816782ca:	48 8d 05 57 fa a3 07 	lea    rax,[rip+0x7a3fa57]        # 0x1890b7d28
   1816782d1:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   1816782d8:	48 89 01             	mov    QWORD PTR [rcx],rax
   1816782db:	48 89 0d 2e 72 2b 0a 	mov    QWORD PTR [rip+0xa2b722e],rcx        # 0x18b92f510
   1816782e2:	e8 19 1c 47 ff       	call   0x180ae9f00
   1816782e7:	90                   	nop
   1816782e8:	b9 02 00 00 00       	mov    ecx,0x2
   1816782ed:	e8 ee 4a 9f fe       	call   0x18006cde0
   1816782f2:	85 c0                	test   eax,eax
   1816782f4:	0f 84 56 f4 ff ff    	je     0x181677750
   1816782fa:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181678301:	48 89 f9             	mov    rcx,rdi
   181678304:	e8 07 4c 9f fe       	call   0x18006cf10
   181678309:	90                   	nop
   18167830a:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181678311:	10 
   181678312:	72 07                	jb     0x18167831b
   181678314:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   18167831b:	48 8d 05 86 06 a4 07 	lea    rax,[rip+0x7a40686]        # 0x1890b89a8
   181678322:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181678327:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18167832e:	00 00 
   181678330:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181678335:	c7 44 24 28 8e 01 00 	mov    DWORD PTR [rsp+0x28],0x18e
   18167833c:	00 
   18167833d:	4c 8d 0d 54 05 a4 07 	lea    r9,[rip+0x7a40554]        # 0x1890b8898
   181678344:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678348:	ba 02 00 00 00       	mov    edx,0x2
   18167834d:	49 89 f8             	mov    r8,rdi
   181678350:	e8 1b 4f 9f fe       	call   0x18006d270
   181678355:	90                   	nop
   181678356:	0f 57 c0             	xorps  xmm0,xmm0
   181678359:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181678360:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181678367:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   18167836e:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181678375:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   18167837c:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181678383:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   18167838a:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181678391:	48 8d 15 b8 0a a4 07 	lea    rdx,[rip+0x7a40ab8]        # 0x1890b8e50
   181678398:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   18167839c:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   1816783a3:	e8 68 54 9f fe       	call   0x18006d810
   1816783a8:	90                   	nop
   1816783a9:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816783ad:	e8 be 4f 9f fe       	call   0x18006d370
   1816783b2:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1816783b9:	48 83 f8 10          	cmp    rax,0x10
   1816783bd:	0f 82 8d f3 ff ff    	jb     0x181677750
   1816783c3:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   1816783ca:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1816783ce:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1816783d5:	72 1f                	jb     0x1816783f6
   1816783d7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1816783db:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1816783df:	4c 29 c1             	sub    rcx,r8
   1816783e2:	48 83 f9 20          	cmp    rcx,0x20
   1816783e6:	0f 83 d3 09 00 00    	jae    0x181678dbf
   1816783ec:	48 83 c0 28          	add    rax,0x28
   1816783f0:	48 89 c2             	mov    rdx,rax
   1816783f3:	4c 89 c1             	mov    rcx,r8
   1816783f6:	e8 e5 34 e3 05       	call   0x1874ab8e0
   1816783fb:	e9 50 f3 ff ff       	jmp    0x181677750
   181678400:	b9 98 02 00 00       	mov    ecx,0x298
   181678405:	e8 92 34 e3 05       	call   0x1874ab89c
   18167840a:	90                   	nop
   18167840b:	48 89 c7             	mov    rdi,rax
   18167840e:	41 b8 98 02 00 00    	mov    r8d,0x298
   181678414:	48 89 c1             	mov    rcx,rax
   181678417:	31 d2                	xor    edx,edx
   181678419:	e8 d2 c2 ec 05       	call   0x1875446f0
   18167841e:	90                   	nop
   18167841f:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181678426:	48 89 f9             	mov    rcx,rdi
   181678429:	e8 b2 ac 47 ff       	call   0x180af30e0
   18167842e:	90                   	nop
   18167842f:	48 8d 05 f2 f9 a3 07 	lea    rax,[rip+0x7a3f9f2]        # 0x1890b7e28
   181678436:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18167843d:	48 89 01             	mov    QWORD PTR [rcx],rax
   181678440:	48 89 0d d1 70 2b 0a 	mov    QWORD PTR [rip+0xa2b70d1],rcx        # 0x18b92f518
   181678447:	e8 b4 1a 47 ff       	call   0x180ae9f00
   18167844c:	90                   	nop
   18167844d:	b9 02 00 00 00       	mov    ecx,0x2
   181678452:	e8 89 49 9f fe       	call   0x18006cde0
   181678457:	85 c0                	test   eax,eax
   181678459:	0f 84 ff f2 ff ff    	je     0x18167775e
   18167845f:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181678466:	48 89 f9             	mov    rcx,rdi
   181678469:	e8 a2 4a 9f fe       	call   0x18006cf10
   18167846e:	90                   	nop
   18167846f:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181678476:	10 
   181678477:	72 07                	jb     0x181678480
   181678479:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181678480:	48 8d 05 21 05 a4 07 	lea    rax,[rip+0x7a40521]        # 0x1890b89a8
   181678487:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18167848c:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181678493:	00 00 
   181678495:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18167849a:	c7 44 24 28 94 01 00 	mov    DWORD PTR [rsp+0x28],0x194
   1816784a1:	00 
   1816784a2:	4c 8d 0d ef 03 a4 07 	lea    r9,[rip+0x7a403ef]        # 0x1890b8898
   1816784a9:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816784ad:	ba 02 00 00 00       	mov    edx,0x2
   1816784b2:	49 89 f8             	mov    r8,rdi
   1816784b5:	e8 b6 4d 9f fe       	call   0x18006d270
   1816784ba:	90                   	nop
   1816784bb:	0f 57 c0             	xorps  xmm0,xmm0
   1816784be:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1816784c5:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1816784cc:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1816784d3:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   1816784da:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1816784e1:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   1816784e8:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   1816784ef:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   1816784f6:	48 8d 15 cb 09 a4 07 	lea    rdx,[rip+0x7a409cb]        # 0x1890b8ec8
   1816784fd:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678501:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181678508:	e8 03 53 9f fe       	call   0x18006d810
   18167850d:	90                   	nop
   18167850e:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678512:	e8 59 4e 9f fe       	call   0x18006d370
   181678517:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   18167851e:	48 83 f8 10          	cmp    rax,0x10
   181678522:	0f 82 36 f2 ff ff    	jb     0x18167775e
   181678528:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   18167852f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678533:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18167853a:	72 1f                	jb     0x18167855b
   18167853c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181678540:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181678544:	4c 29 c1             	sub    rcx,r8
   181678547:	48 83 f9 20          	cmp    rcx,0x20
   18167854b:	0f 83 6e 08 00 00    	jae    0x181678dbf
   181678551:	48 83 c0 28          	add    rax,0x28
   181678555:	48 89 c2             	mov    rdx,rax
   181678558:	4c 89 c1             	mov    rcx,r8
   18167855b:	e8 80 33 e3 05       	call   0x1874ab8e0
   181678560:	e9 f9 f1 ff ff       	jmp    0x18167775e
   181678565:	b9 98 02 00 00       	mov    ecx,0x298
   18167856a:	e8 2d 33 e3 05       	call   0x1874ab89c
   18167856f:	90                   	nop
   181678570:	48 89 c7             	mov    rdi,rax
   181678573:	41 b8 98 02 00 00    	mov    r8d,0x298
   181678579:	48 89 c1             	mov    rcx,rax
   18167857c:	31 d2                	xor    edx,edx
   18167857e:	e8 6d c1 ec 05       	call   0x1875446f0
   181678583:	90                   	nop
   181678584:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   18167858b:	48 89 f9             	mov    rcx,rdi
   18167858e:	e8 4d ab 47 ff       	call   0x180af30e0
   181678593:	90                   	nop
   181678594:	48 8d 05 8d f9 a3 07 	lea    rax,[rip+0x7a3f98d]        # 0x1890b7f28
   18167859b:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   1816785a2:	48 89 01             	mov    QWORD PTR [rcx],rax
   1816785a5:	48 89 0d 74 6f 2b 0a 	mov    QWORD PTR [rip+0xa2b6f74],rcx        # 0x18b92f520
   1816785ac:	e8 4f 19 47 ff       	call   0x180ae9f00
   1816785b1:	90                   	nop
   1816785b2:	b9 02 00 00 00       	mov    ecx,0x2
   1816785b7:	e8 24 48 9f fe       	call   0x18006cde0
   1816785bc:	85 c0                	test   eax,eax
   1816785be:	0f 84 a8 f1 ff ff    	je     0x18167776c
   1816785c4:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   1816785cb:	48 89 f9             	mov    rcx,rdi
   1816785ce:	e8 3d 49 9f fe       	call   0x18006cf10
   1816785d3:	90                   	nop
   1816785d4:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   1816785db:	10 
   1816785dc:	72 07                	jb     0x1816785e5
   1816785de:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   1816785e5:	48 8d 05 bc 03 a4 07 	lea    rax,[rip+0x7a403bc]        # 0x1890b89a8
   1816785ec:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1816785f1:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1816785f8:	00 00 
   1816785fa:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1816785ff:	c7 44 24 28 9a 01 00 	mov    DWORD PTR [rsp+0x28],0x19a
   181678606:	00 
   181678607:	4c 8d 0d 8a 02 a4 07 	lea    r9,[rip+0x7a4028a]        # 0x1890b8898
   18167860e:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678612:	ba 02 00 00 00       	mov    edx,0x2
   181678617:	49 89 f8             	mov    r8,rdi
   18167861a:	e8 51 4c 9f fe       	call   0x18006d270
   18167861f:	90                   	nop
   181678620:	0f 57 c0             	xorps  xmm0,xmm0
   181678623:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   18167862a:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181678631:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181678638:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   18167863f:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181678646:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   18167864d:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181678654:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   18167865b:	48 8d 15 66 08 a4 07 	lea    rdx,[rip+0x7a40866]        # 0x1890b8ec8
   181678662:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678666:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   18167866d:	e8 9e 51 9f fe       	call   0x18006d810
   181678672:	90                   	nop
   181678673:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678677:	e8 f4 4c 9f fe       	call   0x18006d370
   18167867c:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181678683:	48 83 f8 10          	cmp    rax,0x10
   181678687:	0f 82 df f0 ff ff    	jb     0x18167776c
   18167868d:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181678694:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678698:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18167869f:	72 1f                	jb     0x1816786c0
   1816786a1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1816786a5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1816786a9:	4c 29 c1             	sub    rcx,r8
   1816786ac:	48 83 f9 20          	cmp    rcx,0x20
   1816786b0:	0f 83 09 07 00 00    	jae    0x181678dbf
   1816786b6:	48 83 c0 28          	add    rax,0x28
   1816786ba:	48 89 c2             	mov    rdx,rax
   1816786bd:	4c 89 c1             	mov    rcx,r8
   1816786c0:	e8 1b 32 e3 05       	call   0x1874ab8e0
   1816786c5:	e9 a2 f0 ff ff       	jmp    0x18167776c
   1816786ca:	b9 98 02 00 00       	mov    ecx,0x298
   1816786cf:	e8 c8 31 e3 05       	call   0x1874ab89c
   1816786d4:	90                   	nop
   1816786d5:	48 89 c7             	mov    rdi,rax
   1816786d8:	41 b8 98 02 00 00    	mov    r8d,0x298
   1816786de:	48 89 c1             	mov    rcx,rax
   1816786e1:	31 d2                	xor    edx,edx
   1816786e3:	e8 08 c0 ec 05       	call   0x1875446f0
   1816786e8:	90                   	nop
   1816786e9:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   1816786f0:	48 89 f9             	mov    rcx,rdi
   1816786f3:	e8 e8 a9 47 ff       	call   0x180af30e0
   1816786f8:	90                   	nop
   1816786f9:	48 8d 05 28 f9 a3 07 	lea    rax,[rip+0x7a3f928]        # 0x1890b8028
   181678700:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181678707:	48 89 01             	mov    QWORD PTR [rcx],rax
   18167870a:	48 89 0d 17 6e 2b 0a 	mov    QWORD PTR [rip+0xa2b6e17],rcx        # 0x18b92f528
   181678711:	e8 ea 17 47 ff       	call   0x180ae9f00
   181678716:	90                   	nop
   181678717:	b9 02 00 00 00       	mov    ecx,0x2
   18167871c:	e8 bf 46 9f fe       	call   0x18006cde0
   181678721:	85 c0                	test   eax,eax
   181678723:	0f 84 51 f0 ff ff    	je     0x18167777a
   181678729:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181678730:	48 89 f9             	mov    rcx,rdi
   181678733:	e8 d8 47 9f fe       	call   0x18006cf10
   181678738:	90                   	nop
   181678739:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181678740:	10 
   181678741:	72 07                	jb     0x18167874a
   181678743:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   18167874a:	48 8d 05 57 02 a4 07 	lea    rax,[rip+0x7a40257]        # 0x1890b89a8
   181678751:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181678756:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18167875d:	00 00 
   18167875f:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181678764:	c7 44 24 28 a0 01 00 	mov    DWORD PTR [rsp+0x28],0x1a0
   18167876b:	00 
   18167876c:	4c 8d 0d 25 01 a4 07 	lea    r9,[rip+0x7a40125]        # 0x1890b8898
   181678773:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678777:	ba 02 00 00 00       	mov    edx,0x2
   18167877c:	49 89 f8             	mov    r8,rdi
   18167877f:	e8 ec 4a 9f fe       	call   0x18006d270
   181678784:	90                   	nop
   181678785:	0f 57 c0             	xorps  xmm0,xmm0
   181678788:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   18167878f:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181678796:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   18167879d:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   1816787a4:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1816787ab:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   1816787b2:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   1816787b9:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   1816787c0:	48 8d 15 41 07 a4 07 	lea    rdx,[rip+0x7a40741]        # 0x1890b8f08
   1816787c7:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816787cb:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   1816787d2:	e8 39 50 9f fe       	call   0x18006d810
   1816787d7:	90                   	nop
   1816787d8:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816787dc:	e8 8f 4b 9f fe       	call   0x18006d370
   1816787e1:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1816787e8:	48 83 f8 10          	cmp    rax,0x10
   1816787ec:	0f 82 88 ef ff ff    	jb     0x18167777a
   1816787f2:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   1816787f9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1816787fd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181678804:	72 1f                	jb     0x181678825
   181678806:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18167880a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18167880e:	4c 29 c1             	sub    rcx,r8
   181678811:	48 83 f9 20          	cmp    rcx,0x20
   181678815:	0f 83 a4 05 00 00    	jae    0x181678dbf
   18167881b:	48 83 c0 28          	add    rax,0x28
   18167881f:	48 89 c2             	mov    rdx,rax
   181678822:	4c 89 c1             	mov    rcx,r8
   181678825:	e8 b6 30 e3 05       	call   0x1874ab8e0
   18167882a:	e9 4b ef ff ff       	jmp    0x18167777a
   18167882f:	b9 98 02 00 00       	mov    ecx,0x298
   181678834:	e8 63 30 e3 05       	call   0x1874ab89c
   181678839:	90                   	nop
   18167883a:	48 89 c7             	mov    rdi,rax
   18167883d:	41 b8 98 02 00 00    	mov    r8d,0x298
   181678843:	48 89 c1             	mov    rcx,rax
   181678846:	31 d2                	xor    edx,edx
   181678848:	e8 a3 be ec 05       	call   0x1875446f0
   18167884d:	90                   	nop
   18167884e:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181678855:	48 89 f9             	mov    rcx,rdi
   181678858:	e8 83 a8 47 ff       	call   0x180af30e0
   18167885d:	90                   	nop
   18167885e:	48 8d 05 c3 f8 a3 07 	lea    rax,[rip+0x7a3f8c3]        # 0x1890b8128
   181678865:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18167886c:	48 89 01             	mov    QWORD PTR [rcx],rax
   18167886f:	48 89 0d ba 6c 2b 0a 	mov    QWORD PTR [rip+0xa2b6cba],rcx        # 0x18b92f530
   181678876:	e8 85 16 47 ff       	call   0x180ae9f00
   18167887b:	90                   	nop
   18167887c:	b9 02 00 00 00       	mov    ecx,0x2
   181678881:	e8 5a 45 9f fe       	call   0x18006cde0
   181678886:	85 c0                	test   eax,eax
   181678888:	0f 84 fa ee ff ff    	je     0x181677788
   18167888e:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181678895:	48 89 f9             	mov    rcx,rdi
   181678898:	e8 73 46 9f fe       	call   0x18006cf10
   18167889d:	90                   	nop
   18167889e:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   1816788a5:	10 
   1816788a6:	72 07                	jb     0x1816788af
   1816788a8:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   1816788af:	48 8d 05 f2 00 a4 07 	lea    rax,[rip+0x7a400f2]        # 0x1890b89a8
   1816788b6:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1816788bb:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1816788c2:	00 00 
   1816788c4:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1816788c9:	c7 44 24 28 a6 01 00 	mov    DWORD PTR [rsp+0x28],0x1a6
   1816788d0:	00 
   1816788d1:	4c 8d 0d c0 ff a3 07 	lea    r9,[rip+0x7a3ffc0]        # 0x1890b8898
   1816788d8:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   1816788dc:	ba 02 00 00 00       	mov    edx,0x2
   1816788e1:	49 89 f8             	mov    r8,rdi
   1816788e4:	e8 87 49 9f fe       	call   0x18006d270
   1816788e9:	90                   	nop
   1816788ea:	0f 57 c0             	xorps  xmm0,xmm0
   1816788ed:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1816788f4:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1816788fb:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181678902:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181678909:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181678910:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181678917:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   18167891e:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181678925:	48 8d 15 fc 03 a4 07 	lea    rdx,[rip+0x7a403fc]        # 0x1890b8d28
   18167892c:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678930:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181678937:	e8 d4 4e 9f fe       	call   0x18006d810
   18167893c:	90                   	nop
   18167893d:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678941:	e8 2a 4a 9f fe       	call   0x18006d370
   181678946:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   18167894d:	48 83 f8 10          	cmp    rax,0x10
   181678951:	0f 82 31 ee ff ff    	jb     0x181677788
   181678957:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   18167895e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678962:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181678969:	72 1f                	jb     0x18167898a
   18167896b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18167896f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181678973:	4c 29 c1             	sub    rcx,r8
   181678976:	48 83 f9 20          	cmp    rcx,0x20
   18167897a:	0f 83 3f 04 00 00    	jae    0x181678dbf
   181678980:	48 83 c0 28          	add    rax,0x28
   181678984:	48 89 c2             	mov    rdx,rax
   181678987:	4c 89 c1             	mov    rcx,r8
   18167898a:	e8 51 2f e3 05       	call   0x1874ab8e0
   18167898f:	e9 f4 ed ff ff       	jmp    0x181677788
   181678994:	b9 98 02 00 00       	mov    ecx,0x298
   181678999:	e8 fe 2e e3 05       	call   0x1874ab89c
   18167899e:	90                   	nop
   18167899f:	48 89 c7             	mov    rdi,rax
   1816789a2:	41 b8 98 02 00 00    	mov    r8d,0x298
   1816789a8:	48 89 c1             	mov    rcx,rax
   1816789ab:	31 d2                	xor    edx,edx
   1816789ad:	e8 3e bd ec 05       	call   0x1875446f0
   1816789b2:	90                   	nop
   1816789b3:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   1816789ba:	48 89 f9             	mov    rcx,rdi
   1816789bd:	e8 1e a7 47 ff       	call   0x180af30e0
   1816789c2:	90                   	nop
   1816789c3:	48 8d 05 5e f8 a3 07 	lea    rax,[rip+0x7a3f85e]        # 0x1890b8228
   1816789ca:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   1816789d1:	48 89 01             	mov    QWORD PTR [rcx],rax
   1816789d4:	48 89 0d 65 6b 2b 0a 	mov    QWORD PTR [rip+0xa2b6b65],rcx        # 0x18b92f540
   1816789db:	e8 20 15 47 ff       	call   0x180ae9f00
   1816789e0:	90                   	nop
   1816789e1:	b9 02 00 00 00       	mov    ecx,0x2
   1816789e6:	e8 f5 43 9f fe       	call   0x18006cde0
   1816789eb:	85 c0                	test   eax,eax
   1816789ed:	0f 84 a3 ed ff ff    	je     0x181677796
   1816789f3:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   1816789fa:	48 89 f9             	mov    rcx,rdi
   1816789fd:	e8 0e 45 9f fe       	call   0x18006cf10
   181678a02:	90                   	nop
   181678a03:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181678a0a:	10 
   181678a0b:	72 07                	jb     0x181678a14
   181678a0d:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181678a14:	48 8d 05 8d ff a3 07 	lea    rax,[rip+0x7a3ff8d]        # 0x1890b89a8
   181678a1b:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181678a20:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181678a27:	00 00 
   181678a29:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181678a2e:	c7 44 24 28 ad 01 00 	mov    DWORD PTR [rsp+0x28],0x1ad
   181678a35:	00 
   181678a36:	4c 8d 0d 5b fe a3 07 	lea    r9,[rip+0x7a3fe5b]        # 0x1890b8898
   181678a3d:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678a41:	ba 02 00 00 00       	mov    edx,0x2
   181678a46:	49 89 f8             	mov    r8,rdi
   181678a49:	e8 22 48 9f fe       	call   0x18006d270
   181678a4e:	90                   	nop
   181678a4f:	0f 57 c0             	xorps  xmm0,xmm0
   181678a52:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181678a59:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181678a60:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181678a67:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181678a6e:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181678a75:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181678a7c:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181678a83:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181678a8a:	48 8d 15 ff 03 a4 07 	lea    rdx,[rip+0x7a403ff]        # 0x1890b8e90
   181678a91:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678a95:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181678a9c:	e8 6f 4d 9f fe       	call   0x18006d810
   181678aa1:	90                   	nop
   181678aa2:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678aa6:	e8 c5 48 9f fe       	call   0x18006d370
   181678aab:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181678ab2:	48 83 f8 10          	cmp    rax,0x10
   181678ab6:	0f 82 da ec ff ff    	jb     0x181677796
   181678abc:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181678ac3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678ac7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181678ace:	72 1f                	jb     0x181678aef
   181678ad0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181678ad4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181678ad8:	4c 29 c1             	sub    rcx,r8
   181678adb:	48 83 f9 20          	cmp    rcx,0x20
   181678adf:	0f 83 da 02 00 00    	jae    0x181678dbf
   181678ae5:	48 83 c0 28          	add    rax,0x28
   181678ae9:	48 89 c2             	mov    rdx,rax
   181678aec:	4c 89 c1             	mov    rcx,r8
   181678aef:	e8 ec 2d e3 05       	call   0x1874ab8e0
   181678af4:	e9 9d ec ff ff       	jmp    0x181677796
   181678af9:	b9 98 02 00 00       	mov    ecx,0x298
   181678afe:	e8 99 2d e3 05       	call   0x1874ab89c
   181678b03:	90                   	nop
   181678b04:	48 89 c7             	mov    rdi,rax
   181678b07:	41 b8 98 02 00 00    	mov    r8d,0x298
   181678b0d:	48 89 c1             	mov    rcx,rax
   181678b10:	31 d2                	xor    edx,edx
   181678b12:	e8 d9 bb ec 05       	call   0x1875446f0
   181678b17:	90                   	nop
   181678b18:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181678b1f:	48 89 f9             	mov    rcx,rdi
   181678b22:	e8 b9 a5 47 ff       	call   0x180af30e0
   181678b27:	90                   	nop
   181678b28:	48 8d 05 f9 f7 a3 07 	lea    rax,[rip+0x7a3f7f9]        # 0x1890b8328
   181678b2f:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181678b36:	48 89 01             	mov    QWORD PTR [rcx],rax
   181678b39:	48 89 0d 08 6a 2b 0a 	mov    QWORD PTR [rip+0xa2b6a08],rcx        # 0x18b92f548
   181678b40:	e8 bb 13 47 ff       	call   0x180ae9f00
   181678b45:	90                   	nop
   181678b46:	b9 02 00 00 00       	mov    ecx,0x2
   181678b4b:	e8 90 42 9f fe       	call   0x18006cde0
   181678b50:	85 c0                	test   eax,eax
   181678b52:	0f 84 4c ec ff ff    	je     0x1816777a4
   181678b58:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181678b5f:	48 89 f9             	mov    rcx,rdi
   181678b62:	e8 a9 43 9f fe       	call   0x18006cf10
   181678b67:	90                   	nop
   181678b68:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181678b6f:	10 
   181678b70:	72 07                	jb     0x181678b79
   181678b72:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181678b79:	48 8d 05 28 fe a3 07 	lea    rax,[rip+0x7a3fe28]        # 0x1890b89a8
   181678b80:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181678b85:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181678b8c:	00 00 
   181678b8e:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181678b93:	c7 44 24 28 b4 01 00 	mov    DWORD PTR [rsp+0x28],0x1b4
   181678b9a:	00 
   181678b9b:	4c 8d 0d f6 fc a3 07 	lea    r9,[rip+0x7a3fcf6]        # 0x1890b8898
   181678ba2:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678ba6:	ba 02 00 00 00       	mov    edx,0x2
   181678bab:	49 89 f8             	mov    r8,rdi
   181678bae:	e8 bd 46 9f fe       	call   0x18006d270
   181678bb3:	90                   	nop
   181678bb4:	0f 57 c0             	xorps  xmm0,xmm0
   181678bb7:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181678bbe:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181678bc5:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181678bcc:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181678bd3:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181678bda:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181678be1:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181678be8:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181678bef:	48 8d 15 4a 03 a4 07 	lea    rdx,[rip+0x7a4034a]        # 0x1890b8f40
   181678bf6:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678bfa:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181678c01:	e8 0a 4c 9f fe       	call   0x18006d810
   181678c06:	90                   	nop
   181678c07:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678c0b:	e8 60 47 9f fe       	call   0x18006d370
   181678c10:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181678c17:	48 83 f8 10          	cmp    rax,0x10
   181678c1b:	0f 82 83 eb ff ff    	jb     0x1816777a4
   181678c21:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181678c28:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678c2c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181678c33:	72 1f                	jb     0x181678c54
   181678c35:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181678c39:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181678c3d:	4c 29 c1             	sub    rcx,r8
   181678c40:	48 83 f9 20          	cmp    rcx,0x20
   181678c44:	0f 83 75 01 00 00    	jae    0x181678dbf
   181678c4a:	48 83 c0 28          	add    rax,0x28
   181678c4e:	48 89 c2             	mov    rdx,rax
   181678c51:	4c 89 c1             	mov    rcx,r8
   181678c54:	e8 87 2c e3 05       	call   0x1874ab8e0
   181678c59:	e9 46 eb ff ff       	jmp    0x1816777a4
   181678c5e:	b9 98 02 00 00       	mov    ecx,0x298
   181678c63:	e8 34 2c e3 05       	call   0x1874ab89c
   181678c68:	90                   	nop
   181678c69:	48 89 c7             	mov    rdi,rax
   181678c6c:	41 b8 98 02 00 00    	mov    r8d,0x298
   181678c72:	48 89 c1             	mov    rcx,rax
   181678c75:	31 d2                	xor    edx,edx
   181678c77:	e8 74 ba ec 05       	call   0x1875446f0
   181678c7c:	90                   	nop
   181678c7d:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   181678c84:	48 89 f9             	mov    rcx,rdi
   181678c87:	e8 54 a4 47 ff       	call   0x180af30e0
   181678c8c:	90                   	nop
   181678c8d:	48 8d 05 94 f7 a3 07 	lea    rax,[rip+0x7a3f794]        # 0x1890b8428
   181678c94:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   181678c9b:	48 89 01             	mov    QWORD PTR [rcx],rax
   181678c9e:	48 89 0d 93 68 2b 0a 	mov    QWORD PTR [rip+0xa2b6893],rcx        # 0x18b92f538
   181678ca5:	e8 56 12 47 ff       	call   0x180ae9f00
   181678caa:	90                   	nop
   181678cab:	b9 02 00 00 00       	mov    ecx,0x2
   181678cb0:	e8 2b 41 9f fe       	call   0x18006cde0
   181678cb5:	85 c0                	test   eax,eax
   181678cb7:	0f 84 f5 ea ff ff    	je     0x1816777b2
   181678cbd:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   181678cc4:	48 89 f9             	mov    rcx,rdi
   181678cc7:	e8 44 42 9f fe       	call   0x18006cf10
   181678ccc:	90                   	nop
   181678ccd:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181678cd4:	10 
   181678cd5:	72 07                	jb     0x181678cde
   181678cd7:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181678cde:	48 8d 05 c3 fc a3 07 	lea    rax,[rip+0x7a3fcc3]        # 0x1890b89a8
   181678ce5:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181678cea:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181678cf1:	00 00 
   181678cf3:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181678cf8:	c7 44 24 28 bd 01 00 	mov    DWORD PTR [rsp+0x28],0x1bd
   181678cff:	00 
   181678d00:	4c 8d 0d 91 fb a3 07 	lea    r9,[rip+0x7a3fb91]        # 0x1890b8898
   181678d07:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678d0b:	ba 02 00 00 00       	mov    edx,0x2
   181678d10:	49 89 f8             	mov    r8,rdi
   181678d13:	e8 58 45 9f fe       	call   0x18006d270
   181678d18:	90                   	nop
   181678d19:	0f 57 c0             	xorps  xmm0,xmm0
   181678d1c:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   181678d23:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181678d2a:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   181678d31:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181678d38:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   181678d3f:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181678d46:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181678d4d:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   181678d54:	48 8d 15 1d 02 a4 07 	lea    rdx,[rip+0x7a4021d]        # 0x1890b8f78
   181678d5b:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678d5f:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   181678d66:	e8 a5 4a 9f fe       	call   0x18006d810
   181678d6b:	90                   	nop
   181678d6c:	48 8d 4d 20          	lea    rcx,[rbp+0x20]
   181678d70:	e8 fb 45 9f fe       	call   0x18006d370
   181678d75:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181678d7c:	48 83 f8 10          	cmp    rax,0x10
   181678d80:	0f 82 2c ea ff ff    	jb     0x1816777b2
   181678d86:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181678d8d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181678d91:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181678d98:	72 1b                	jb     0x181678db5
   181678d9a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181678d9e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181678da2:	4c 29 c1             	sub    rcx,r8
   181678da5:	48 83 f9 20          	cmp    rcx,0x20
   181678da9:	73 14                	jae    0x181678dbf
   181678dab:	48 83 c0 28          	add    rax,0x28
   181678daf:	48 89 c2             	mov    rdx,rax
   181678db2:	4c 89 c1             	mov    rcx,r8
   181678db5:	e8 26 2b e3 05       	call   0x1874ab8e0
   181678dba:	e9 f3 e9 ff ff       	jmp    0x1816777b2
   181678dbf:	e8 c8 45 e9 05       	call   0x18750d38c
   181678dc4:	cc                   	int3
