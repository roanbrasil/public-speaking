SELECT
	SC5.C5_NUM 	AS PED, 
	SC5.C5_VEND1 	AS REPRES,
	SA1.A1_NOME 	AS NOME, 
	(
		SELECT sum ((C6_QTDVEN-C6_QTDENT))  
		FROM SC6010 C6, SC9010 C9
		WHERE C6_NUM = SC5.C5_NUM
		AND C6_NUM = C9_PEDIDO
		AND C6.C6_PRODUTO = C9.C9_PRODUTO
		AND C9.C9_NFISCAL = ''
		AND C9.C9_XLIST = ''
		AND C6.D_E_L_E_T_ = ''
		AND C9.D_E_L_E_T_ = ''
		AND C6_BLQ <> 'R'
		AND C6_LOCAL = '05'
		AND C9_LOCAL = '05'
	) AS QTDFAL,
	(
		SELECT sum ((C6_QTDVEN-C6_QTDENT) * C6_PRCVEN) 
		FROM SC6010 C6, SC9010 C9
		WHERE C6_NUM = SC5.C5_NUM
		AND C6_NUM = C9_PEDIDO
		AND C6.C6_PRODUTO = C9.C9_PRODUTO
		AND C9.C9_NFISCAL = ''
		AND C9.C9_XLIST = ''
		AND C6.D_E_L_E_T_ = ''
		AND C9.D_E_L_E_T_ = ''
		AND C6_BLQ <> 'R'
		AND C6_LOCAL = '05'
		AND C9_LOCAL = '05'
	) AS VALFAL,
	(
		SELECT sum (((C6_QTDVEN-C6_QTDENT) * C6_PRCVEN)-(C6_XQTD05*C6_PRCVEN)) 
		FROM SC6010 C6, SC9010 C9
		WHERE C6_NUM = SC5.C5_NUM
		AND C6_NUM = C9_PEDIDO
		AND C6.C6_PRODUTO = C9.C9_PRODUTO
		AND C9.C9_NFISCAL = ''
		AND C9.C9_XLIST = ''
		AND C6.D_E_L_E_T_ = ''
		AND C9.D_E_L_E_T_ = ''
		AND C6_BLQ <> 'R'
		AND C6_LOCAL = '05'
		AND C9_LOCAL = '05'
	) AS VALOR,
	SE4.E4_COND AS COND,
	SC5.C5_OBSPED AS OBS,
	SC5.C5_PREVIST as PREV,
	SC5.C5_XST05 AS ST,
	SC5.C5_XFRET AS FRET,
	(
		SELECT SUM(C6_VALOR) FROM SC6010 C6, SC9010 C9
		WHERE C6_NUM = SC5.C5_NUM
		AND C6.C6_NUM = C9.C9_PEDIDO
		AND C6.C6_PRODUTO = C9.C9_PRODUTO
		AND C9.C9_NFISCAL = ''											
		AND C9.C9_XLIST = ''
		AND C6.D_E_L_E_T_ = ''
		AND C9.D_E_L_E_T_ = ''
		AND C6.C6_LOCAL = '05'
		AND C6.C6_BLQ <> 'R'
	) AS TOT
FROM SC5010 SC5,SC6010 SC6, SC9010 SC9,SA1010 SA1,SF4010 SF4,SE4010 SE4
WHERE SA1.A1_FILIAL = '  '
  AND SE4.E4_FILIAL = '  '
  AND SC5.C5_FILIAL = SC6.C6_FILIAL
  AND SF4.F4_FILIAL = '  '
  AND (SC5.C5_XFLAG = 'PE' OR SC5.C5_XFLAG = 'PAR' OR SC5.C5_XFLAG = 'LIB')
  AND  (SC5.C5_XSEP ='' or SC5.C5_XSEP ='1')		
  AND (SC6.C6_XFLAG = 'PE' or SC6.C6_LOCAL = '05' )
  AND SC5.C5_NOTA = ''
  AND SC5.C5_NUM = SC6.C6_NUM
  AND SC6.C6_NUM = SC9.C9_PEDIDO
  AND SC5.C5_NUM = SC9.C9_PEDIDO
  AND SC6.C6_PRODUTO = SC9.C9_PRODUTO
  AND SC9.C9_XLIST = ''	
  AND SC9.C9_NFISCAL = ''
  AND SC5.C5_CLIENT = SA1.A1_COD
  AND SC6.C6_BLQ <> 'R'
  AND SC5.C5_TIPO = 'N'
  AND SC5.C5_CONDPAG = SE4.E4_CODIGO
  AND SC6.C6_TES = SF4.F4_CODIGO
  AND SF4.F4_ESTOQUE = 'S'
  AND SC6.C6_LOCAL = '05'
  AND (SC6.C6_QTDVEN-SC6.C6_QTDENT) > 0
  AND SC9.D_E_L_E_T_ = ''
  AND SC5.D_E_L_E_T_ = ''
  AND SC6.D_E_L_E_T_ = ''
  AND SF4.D_E_L_E_T_ = ''
  AND SE4.D_E_L_E_T_ = ''
  AND SA1.D_E_L_E_T_ = ''
  AND NOT EXISTS ( 
    SELECT 1 
      FROM SC9010
      WHERE C9_FILIAL  = '  '
      AND C9_PEDIDO    = SC5.C5_NUM 
      AND D_E_L_E_T_   = '' 
      AND C9_BLCRED   <> '' 
      AND C9_NFISCAL   = '' 
      AND C9_BLCRED   <> '10' 
  )
GROUP BY 
  SC5.C5_NUM, 
  SC5.C5_VEND1,
  SA1.A1_NOME,
  SE4.E4_COND ,
  SC5.C5_OBSPED,
  SC5.C5_PREVIST,
  SC5.C5_XST05,
  SC5.C5_XFRET
ORDER BY SA1.A1_NOME;