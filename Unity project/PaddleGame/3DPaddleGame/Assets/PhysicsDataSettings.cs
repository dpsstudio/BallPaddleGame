using UnityEngine;
using System.Collections;

public class PhysicsDataSettings : MonoBehaviour {
	
	public UITiledSprite backgroundSprite;
	public UISlider gravitySlider;
	public UISlider cameraAccelerationSlider;
	public UISlider cameraSensivitySlider;
	public UISlider ballDiameterSlider;
	public UISlider ballWeightSlider;
	public UISlider ballPushForceSlider;
	public UISlider maxRopeLengthSlider;
	public UISlider ropeTensionSlider;
	public UISlider roomSizeSlider;
	public GameObject backButton;
	
	private float tempFloat;
	// Use this for initialization
	void Start () {
		PhysicsDataManager.Instance.physicsData.LoadData();
		
		backgroundSprite.transform.localScale = new Vector3(Screen.width,Screen.height,1.0f);
		
		UIEventListener.Get(backButton.gameObject).onClick+=OnBackButtonClick;
		
		//Setup sliders
		UpdateSliderValue(gravitySlider,PhysicsDataManager.Instance.physicsData.Gravity,GameConstants.MIN_GRAVITY,GameConstants.MAX_GRAVITY,"Gravity");
		
		UpdateSliderValue(cameraAccelerationSlider,PhysicsDataManager.Instance.physicsData.CameraAcceleration,
			GameConstants.MIN_CAMERA_ACCELERATION,GameConstants.MAX_CAMERA_ACCELERATION,"Camera acceleration");
		
		UpdateSliderValue(cameraSensivitySlider, PhysicsDataManager.Instance.physicsData.CameraSensivity,
			GameConstants.MIN_CAMERA_SENSITIVITY, GameConstants.MAX_CAMERA_SENSITIVITY, "Camera sensitivty");
		
		UpdateSliderValue(roomSizeSlider, PhysicsDataManager.Instance.physicsData.RoomSize.x, GameConstants.MIN_ROOM_SIZE,
			GameConstants.MAX_ROOM_SIZE, "Room size");
		
		UpdateSliderValue(ropeTensionSlider, PhysicsDataManager.Instance.physicsData.RopeTension, GameConstants.MIN_ROPE_TENSION,
			GameConstants.MAX_ROPE_TENSION, "Rope tension");
		
		UpdateSliderValue(maxRopeLengthSlider,PhysicsDataManager.Instance.physicsData.MaxRopeLength,GameConstants.MIN_ROPE_LENGTH,
			GameConstants.MAX_ROPE_LENGTH,"Max rope length");
		
		UpdateSliderValue(ballDiameterSlider, PhysicsDataManager.Instance.physicsData.BallDiameter, GameConstants.MIN_BALL_SIZE,
			GameConstants.MAX_BALL_SIZE,"Ball size");
		
		UpdateSliderValue(ballWeightSlider, PhysicsDataManager.Instance.physicsData.BallWeight, GameConstants.MIN_BALL_WEIGHT,
			GameConstants.MAX_BALL_WEIGHT, "Ball weight");
		
		UpdateSliderValue(ballPushForceSlider, PhysicsDataManager.Instance.physicsData.BallPushForce, GameConstants.MIN_BALL_PUSH_FORCE,
			GameConstants.MAX_BALL_PUSH_FORCE, "Ball push force");
		
	}

	void OnBackButtonClick(GameObject go)
	{
		PhysicsDataManager.Instance.physicsData.SaveData();
		Application.LoadLevelAsync("MainScene");
	}

	private void UpdateSliderValue(UISlider target, float requestedValue, float minValue, float maxValue, string sliderLocale = "Value"){
		target.sliderValue = requestedValue / maxValue;
		UpdateSliderLabel(target,requestedValue,sliderLocale);
		//Debug.Log("Slider value: " + target.sliderValue + " requestedValue: " + requestedValue);
	}
	
	private void UpdateSliderLabel(UISlider target, float requestedValue, string sliderLocale = "Value")
	{
		target.GetComponentInChildren<UILabel>().text = sliderLocale + ": " + requestedValue.ToString("F2");//Show only one digit
	}
	
	private void UpdateValueBySlider(UISlider slider, out float targetValue, float minValue, float maxValue, string sliderLocale = "Value")
	{
		targetValue = Mathf.Max(slider.sliderValue * maxValue, minValue);
		UpdateSliderLabel(slider,targetValue,sliderLocale);
		//Debug.Log("Target value: " + targetValue + " Slider value: " + slider.sliderValue);
			
	}
	
	public void OnGravitySliderChange()
	{
		UpdateValueBySlider(gravitySlider, out tempFloat,GameConstants.MIN_GRAVITY,GameConstants.MAX_GRAVITY,"Gravity");
		PhysicsDataManager.Instance.physicsData.Gravity = tempFloat;
	}
	public void OnBallPushForceSliderChange()
	{
		UpdateValueBySlider(ballPushForceSlider, out tempFloat,GameConstants.MIN_BALL_PUSH_FORCE,GameConstants.MAX_BALL_PUSH_FORCE,"Ball push force");
		PhysicsDataManager.Instance.physicsData.BallPushForce = tempFloat;
		
	}
	public void OnBallSizeSliderChange()
	{
		UpdateValueBySlider(ballDiameterSlider, out tempFloat,GameConstants.MIN_BALL_SIZE,GameConstants.MAX_BALL_SIZE,"Ball size");
		PhysicsDataManager.Instance.physicsData.BallDiameter = tempFloat;
	}
	
	public void OnBallWeightSliderChange()
	{
		UpdateValueBySlider(ballWeightSlider, out tempFloat,GameConstants.MIN_BALL_WEIGHT,GameConstants.MAX_BALL_WEIGHT,"Ball weight");
		PhysicsDataManager.Instance.physicsData.BallWeight = tempFloat;
		
	}
	
	public void OnCameraAccelerationSliderChange()
	{
		UpdateValueBySlider(cameraAccelerationSlider, out tempFloat,GameConstants.MIN_CAMERA_ACCELERATION,
			GameConstants.MAX_CAMERA_ACCELERATION,"Camera acceleration");
		PhysicsDataManager.Instance.physicsData.CameraAcceleration = tempFloat;
		
	}
	
	public void OnCameraSensivitySliderChange()
	{
		UpdateValueBySlider(cameraSensivitySlider, out tempFloat,GameConstants.MIN_CAMERA_SENSITIVITY,
			GameConstants.MAX_CAMERA_SENSITIVITY,"Camera sensitivity");
		PhysicsDataManager.Instance.physicsData.CameraSensivity = tempFloat;
		
	}
	public void OnMaxRopeLengthSliderChange()
	{
		UpdateValueBySlider(maxRopeLengthSlider, out tempFloat,GameConstants.MIN_ROPE_LENGTH,
			GameConstants.MAX_ROPE_LENGTH,"Max rope length");
		PhysicsDataManager.Instance.physicsData.MaxRopeLength = tempFloat;
		
	}
	
	public void OnRopeTensionSliderChange(){
		UpdateValueBySlider(ropeTensionSlider, out tempFloat,GameConstants.MIN_ROPE_TENSION,
			GameConstants.MAX_ROPE_TENSION,"Rope tension");
		PhysicsDataManager.Instance.physicsData.RopeTension = tempFloat;
		
	}
	
	public void OnRoomSizeSliderChange()
	{
		UpdateValueBySlider(roomSizeSlider, out tempFloat,GameConstants.MIN_ROOM_SIZE,
			GameConstants.MAX_ROOM_SIZE,"Room size");
		PhysicsDataManager.Instance.physicsData.RoomSize = new Vector3(tempFloat,tempFloat,tempFloat);
		
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
