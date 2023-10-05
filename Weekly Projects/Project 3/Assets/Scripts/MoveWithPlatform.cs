using UnityEngine;

public class MoveWithPlatform : MonoBehaviour
{
    public Transform currentPlatform;  // 玩家当前站立的平台
    private Rigidbody rb;  // 玩家的 Rigidbody 组件

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        if (currentPlatform != null)
        {
            // 计算玩家应该移动到的新位置
            Vector3 newPosition = currentPlatform.position + new Vector3(0, 1f, 0);  // 假设玩家站立在平台上方1个单位的高度

            // 使用 Rigidbody 的 MovePosition 方法更新玩家的位置
            rb.MovePosition(newPosition);
        }
    }
}
