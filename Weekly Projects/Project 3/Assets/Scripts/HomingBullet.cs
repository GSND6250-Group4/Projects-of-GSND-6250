using UnityEngine;

public class HomingBullet : MonoBehaviour
{
    public float speed = 10f;
    public Transform target;

    void Update()
    {
        if (target)
        {
            Vector3 direction = (target.position - transform.position).normalized;
            transform.Translate(direction * speed * Time.deltaTime);
        }
        else
        {
            Destroy(gameObject); // 如果目标不存在则销毁子弹
        }
    }
}
