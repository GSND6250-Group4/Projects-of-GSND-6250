using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;  // 单例模式，方便从其他脚本访问

    public int totalItems = 3;  // 总物品数
    public int totalItems2 = 5;  // 总物品数
    public int interactedItems = 0;  // 已交互物品数

    public Infinite infinite;  // 引用无限走廊脚本
    public bool shouldChangeScene = false;
    public bool shouldChangeScene2 = false;

    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
        else if (instance != this)
        {
            Destroy(gameObject);
        }

        DontDestroyOnLoad(gameObject);  // 使 GameManager 在场景加载时不被销毁
    }
    
    public void ItemInteracted()
    {

        interactedItems++;
        if (interactedItems == totalItems)
        {
            shouldChangeScene = true;

        }
        if (interactedItems == totalItems2)
        {
            shouldChangeScene2 = true;
            Debug.Log("----------------------------------------------------");
        }
    }


}
