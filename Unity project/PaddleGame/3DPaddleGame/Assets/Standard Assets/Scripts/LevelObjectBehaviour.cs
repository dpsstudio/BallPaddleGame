using UnityEngine;
using System.Collections;

public class LevelObjectBehaviour : MonoBehaviour
{
	public GameController gameController;
	
	Vector3 sourcePos = new Vector3();
	
	// Use this for initialization
	void Start ()
	{
		sourcePos = gameObject.transform.position;
	}
	
	// Update is called once per frame
	void Update ()
	{
	
	}
	void OnTriggerEnter(Collider other)
	{
		if(other.name == "RopeBall")
		{
			if(gameController!=null) gameController.OnBallHit(gameObject);
			Debug.Log("Virtual ball collision");
		}
	}
}

