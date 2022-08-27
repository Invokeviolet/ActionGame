using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    [Header("[플레이어 기본 속성]")]
    [SerializeField] float speed = 1f;
    [SerializeField] float attackPower = 50f;
    [SerializeField] float attackRange = 5f;
    [SerializeField] int maxHP = 100;
    [SerializeField] int curHP = 0;

    CharacterController myCC=null;

    bool isDeath { get { return (curHP <= 0); } }

    bool isAttackProcess = false;
    Vector3 moveDir = Vector3.zero;
    private void Awake()
    {
        myCC = GetComponent<CharacterController>();
    }
    private void Start()
    {
        curHP = maxHP;
    }
    private void Update()
    {
        
        if (isDeath) return;


        float xAxis = Input.GetAxis("Horizontal");
        float zAxis = Input.GetAxis("Vertical");


        bool isMove = (xAxis!=0f||zAxis!=0f); //입력값이 있을때를 체크해주기 위함

        if (isMove) 
        {
            moveDir = Vector3.right * xAxis + Vector3.forward * zAxis;
            transform.rotation = Quaternion.LookRotation(moveDir);

            myCC.Move(moveDir * speed * Time.deltaTime);
        }

        if (Input.GetKeyDown(KeyCode.Return))
        {
            Debug.Log("## 도라에몽 주먹 발사!!!");
            isAttackProcess = true;
            //공격애니메이션
        }
        if (Input.GetKeyDown(KeyCode.A)) 
        {
            curHP -= 25;
            Debug.Log (isDeath + " ## 아야!! " + curHP);
        }

    }

}
