/*
*   @Author: Treasure
*   @Time: 2021/9/28 14:32
 */

package main

type Options struct {
}

type (
	HookArgs struct {
		Event string `json:"event_name"`

		Branch string `json:"ref"`
	}

	LocalConfig struct {
		Token string `json:"token"`

		Branch string `json:"branch"`

		Event string `json:"event"`
	}
)
