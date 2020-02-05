using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

// private AudioSource scream = 
public class RestartMaze : MonoBehaviour {

	// Use this for initialization
	void Start () {
        LevelGenerator.Maze = 1;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
            GameObject.Find("WhisperSource").GetComponent<AudioSource>().Stop();

			SceneManager.LoadScene("Title");

		}
	}
}
