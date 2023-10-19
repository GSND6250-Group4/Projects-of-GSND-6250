using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        RaycastHit hit;
        if (Physics.Raycast(transform.position, transform.forward, out hit, 5f))  // 5f是射线的长度
        {
            Debug.Log("Blocked by: " + hit.collider.name);  // 在控制台打印被阻挡物体的名称
        }
    }
}
