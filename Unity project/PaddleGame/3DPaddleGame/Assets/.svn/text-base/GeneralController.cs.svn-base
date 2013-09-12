using UnityEngine;
using System.Collections;

public class GeneralController : MonoBehaviour {
	
	public GameObject settingsButton;
	// Use this for initialization
	void Start () {
		
		UIEventListener.Get(settingsButton).onClick+=OnSettingsButtonClick;

	}
	void OnSettingsButtonClick(GameObject go)
	{
		//Debug.Log("Settings button click");
		Application.LoadLevelAsync("PhysicsControlScene");
	}
	// Update is called once per frame
	void Update () {
	
	}
}
