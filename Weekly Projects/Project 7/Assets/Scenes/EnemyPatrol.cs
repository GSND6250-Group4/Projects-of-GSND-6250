using UnityEngine;

public class EnemyPatrol : MonoBehaviour
{
    public Transform[] patrolPoints;
    public float moveSpeed = 2f;
    public float waitAtPointTime = 2f;
    public float rotateSpeed = 120f;

    private int currentPatrolIndex;
    private float waitTimer;
    private bool isWaiting;
    private Quaternion targetRotation;

    void Start()
    {
        if (patrolPoints.Length >= 2)
        {
            currentPatrolIndex = 0;
            transform.position = patrolPoints[currentPatrolIndex].position;
            isWaiting = false;
            // 初始化targetRotation为第一次旋转
            targetRotation = Quaternion.Euler(0, transform.eulerAngles.y + 180f, 0);
        }
        else
        {
            Debug.LogError("Not enough patrol points for patrolling behaviour.");
        }
    }

    void Update()
    {
        if (!isWaiting)
        {
            MoveToNextPoint();
        }
        else
        {
            if (waitTimer > 0f)
            {
                waitTimer -= Time.deltaTime;
            }
            else
            {
                isWaiting = false;
                // 准备下一个点的旋转
                SetNextRotation();
                // 更新下一个巡逻点的索引
                currentPatrolIndex = (currentPatrolIndex + 1) % patrolPoints.Length;
            }
        }

        // 执行旋转
        if (isWaiting)
        {
            RotateInPlace();
        }
    }

    void MoveToNextPoint()
    {
        Transform targetPoint = patrolPoints[currentPatrolIndex];
        transform.position = Vector3.MoveTowards(transform.position, targetPoint.position, moveSpeed * Time.deltaTime);

        if (Vector3.Distance(transform.position, targetPoint.position) < 0.1f)
        {
            // 到达巡逻点，开始等待
            isWaiting = true;
            waitTimer = waitAtPointTime;
            // 已经到达一个巡逻点，准备旋转
            SetNextRotation();
        }
    }

    void RotateInPlace()
    {
        // 旋转直到达到目标角度
        transform.rotation = Quaternion.RotateTowards(transform.rotation, targetRotation, rotateSpeed * Time.deltaTime);
    }

    void SetNextRotation()
    {
        // 计算新的旋转目标
        targetRotation = Quaternion.Euler(0, transform.eulerAngles.y + 180f, 0);
    }
}
